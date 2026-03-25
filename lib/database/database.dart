import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tariffs.dart';
import 'tables/parking_records.dart';
import 'tables/subscribers.dart';
import 'tables/large_vehicle_plates.dart';
import 'tables/registered_vehicles.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Tariffs,
  ParkingRecords,
  Subscribers,
  SubscriberPlates,
  LargeVehiclePlates,
  RegisteredVehicles,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultTariff();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(parkingRecords, parkingRecords.isLargeVehicle);
            await m.addColumn(parkingRecords, parkingRecords.isDailySubscriber);
            await m.addColumn(subscribers, subscribers.subscriberType);
            await m.addColumn(subscribers, subscribers.dailyFee);
            await m.createTable(largeVehiclePlates);
          }
          if (from < 3) {
            await m.createTable(registeredVehicles);
          }
          if (from < 4) {
            await m.addColumn(tariffs, tariffs.dailySubscriptionPrice);
          }
        },
      );

  // ─── Seed ────────────────────────────────────────────────────────────────

  Future<void> _seedDefaultTariff() async {
    await into(tariffs).insert(TariffsCompanion.insert(
      name: 'Varsayılan Tarife',
      bracketsJson:
          '[{"upToMinutes":60,"price":100.0},{"upToMinutes":120,"price":150.0},{"upToMinutes":240,"price":200.0}]',
      fullDayPrice: 400.0,
      monthlyPrice: 4000.0,
      dailySubscriptionPrice: const Value(150.0),
      validFrom: DateTime.now(),
    ));
  }

  // ─── Tariff queries ───────────────────────────────────────────────────────

  Stream<List<Tariff>> watchAllTariffs() =>
      (select(tariffs)..orderBy([(t) => OrderingTerm.desc(t.validFrom)])).watch();

  Stream<Tariff?> watchActiveTariff() =>
      (select(tariffs)..where((t) => t.isActive.equals(true))..limit(1))
          .watchSingleOrNull();

  Future<Tariff?> getActiveTariff() =>
      (select(tariffs)..where((t) => t.isActive.equals(true))..limit(1))
          .getSingleOrNull();

  Future<void> switchToNewTariff(TariffsCompanion newTariff) async {
    await transaction(() async {
      await (update(tariffs)..where((t) => t.isActive.equals(true))).write(
        TariffsCompanion(
          isActive: const Value(false),
          validTo: Value(DateTime.now()),
        ),
      );
      await into(tariffs).insert(newTariff);
    });
  }

  Future<void> editActiveTariff(TariffsCompanion updated) async {
    await (update(tariffs)..where((t) => t.id.equals(updated.id.value)))
        .write(updated);
  }

  Future<int> deactivateTariff(int id) =>
      (update(tariffs)..where((t) => t.id.equals(id))).write(
        TariffsCompanion(
          isActive: const Value(false),
          validTo: Value(DateTime.now()),
        ),
      );

  Future<Tariff?> getTariffById(int id) =>
      (select(tariffs)..where((t) => t.id.equals(id))).getSingleOrNull();

  // ─── Parking record queries ───────────────────────────────────────────────

  Stream<List<ParkingRecord>> watchInsideCars() =>
      (select(parkingRecords)
            ..where((r) => r.status.equals('inside'))
            ..orderBy([(r) => OrderingTerm.asc(r.entryTime)]))
          .watch();

  Stream<int> watchInsideCarsCount() =>
      watchInsideCars().map((list) => list.length);

  Stream<double> watchTodayRevenue() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return (select(parkingRecords)
          ..where((r) =>
              r.exitTime.isBiggerOrEqualValue(today) &
              r.exitTime.isSmallerOrEqualValue(tomorrow) &
              r.status.equals('exited')))
        .watch()
        .map((list) =>
            list.fold(0.0, (sum, r) => sum + (r.calculatedCost ?? 0.0)));
  }

  Future<ParkingRecord?> getRecordByPlate(String plate) =>
      (select(parkingRecords)
            ..where((r) =>
                r.plate.equals(plate.toUpperCase()) &
                r.status.equals('inside')))
          .getSingleOrNull();

  Future<int> insertParkingRecord(ParkingRecordsCompanion entry) =>
      into(parkingRecords).insert(entry);

  Future<bool> updateParkingRecord(ParkingRecordsCompanion entry) =>
      update(parkingRecords).replace(entry);

  Future<void> exitCar({
    required int recordId,
    required DateTime exitTime,
    required double calculatedCost,
    required String tariffNameSnapshot,
    required bool isSubscriber,
    required bool isLargeVehicle,
    required bool isDailySubscriber,
  }) =>
      (update(parkingRecords)..where((r) => r.id.equals(recordId))).write(
        ParkingRecordsCompanion(
          exitTime: Value(exitTime),
          calculatedCost: Value(calculatedCost),
          tariffNameSnapshot: Value(tariffNameSnapshot),
          isSubscriber: Value(isSubscriber),
          isLargeVehicle: Value(isLargeVehicle),
          isDailySubscriber: Value(isDailySubscriber),
          status: const Value('exited'),
        ),
      );

  /// Inserts a revenue-only record (for subscription payments collected at entry).
  Future<void> insertSubscriptionPaymentRecord({
    required String plate,
    required double amount,
    String notes = 'Aylık Abonman Ödemesi',
  }) async {
    final now = DateTime.now();
    await into(parkingRecords).insert(ParkingRecordsCompanion.insert(
      plate: plate.toUpperCase(),
      entryTime: now,
      exitTime: Value(now),
      calculatedCost: Value(amount),
      isSubscriber: const Value(false),
      isLargeVehicle: const Value(false),
      isDailySubscriber: const Value(false),
      status: const Value('exited'),
      notes: Value(notes),
    ));
  }

  Future<List<String>> searchDistinctPlates(String rawQuery,
      {int limit = 6}) async {
    final q = rawQuery.replaceAll(' ', '');
    if (q.isEmpty) return [];
    final rows = await (selectOnly(parkingRecords)
          ..addColumns([parkingRecords.plate])
          ..groupBy([parkingRecords.plate]))
        .get();
    return rows
        .map((r) => r.read(parkingRecords.plate)!)
        .where((p) => p.replaceAll(' ', '').contains(q))
        .take(limit)
        .toList();
  }

  Future<List<ParkingRecord>> getRecordsByDateRange(
          DateTime from, DateTime to) =>
      (select(parkingRecords)
            ..where((r) =>
                r.exitTime.isBiggerOrEqualValue(from) &
                r.exitTime.isSmallerOrEqualValue(to) &
                r.status.equals('exited')))
          .get();

  Stream<List<ParkingRecord>> watchRecordsByDateRange(
          DateTime from, DateTime to) =>
      (select(parkingRecords)
            ..where((r) =>
                r.exitTime.isBiggerOrEqualValue(from) &
                r.exitTime.isSmallerOrEqualValue(to) &
                r.status.equals('exited'))
            ..orderBy([(r) => OrderingTerm.desc(r.exitTime)]))
          .watch();

  Stream<List<ParkingRecord>> watchAllRecords() =>
      (select(parkingRecords)
            ..orderBy([(r) => OrderingTerm.desc(r.entryTime)]))
          .watch();

  Future<void> deleteParkingRecord(int id) =>
      (delete(parkingRecords)..where((r) => r.id.equals(id))).go();

  Future<bool> hasPlateAlreadyPaidDailyFeeToday(String plate) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final rows = await (select(parkingRecords)
          ..where((r) =>
              r.plate.equals(plate.toUpperCase()) &
              r.isDailySubscriber.equals(true) &
              r.status.equals('exited') &
              r.exitTime.isBiggerOrEqualValue(todayStart) &
              r.exitTime.isSmallerOrEqualValue(todayEnd)))
        .get();
    return rows.any((r) => (r.calculatedCost ?? 0) > 0);
  }

  // ─── Subscriber queries (legacy) ──────────────────────────────────────────

  Stream<List<Subscriber>> watchAllSubscribers() =>
      (select(subscribers)..orderBy([(s) => OrderingTerm.desc(s.startDate)]))
          .watch();

  Future<int> insertSubscriber(SubscribersCompanion entry) =>
      into(subscribers).insert(entry);

  Future<bool> updateSubscriber(SubscribersCompanion entry) =>
      update(subscribers).replace(entry);

  Future<void> deleteSubscriberWithPlates(int id) async {
    await transaction(() async {
      await (delete(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(id)))
          .go();
      await (delete(subscribers)..where((s) => s.id.equals(id))).go();
    });
  }

  Future<void> renewSubscriber(int id, DateTime newEndDate) =>
      (update(subscribers)..where((s) => s.id.equals(id))).write(
        SubscribersCompanion(
          endDate: Value(newEndDate),
          isActive: const Value(true),
        ),
      );

  Future<void> replaceSubscriberPlates(
      int subscriberId, List<String> plates) async {
    await transaction(() async {
      await (delete(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(subscriberId)))
          .go();
      for (final plate in plates) {
        await into(subscriberPlates).insert(SubscriberPlatesCompanion.insert(
          subscriberId: subscriberId,
          plate: plate.toUpperCase().trim(),
        ));
      }
    });
  }

  Stream<List<SubscriberPlate>> watchAllSubscriberPlates() =>
      select(subscriberPlates).watch();

  Stream<List<SubscriberPlate>> watchPlatesForSubscriber(int subscriberId) =>
      (select(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(subscriberId)))
          .watch();

  Future<Subscriber?> findActiveSubscriberByPlate(String plate) async {
    final now = DateTime.now();
    final matching = await (select(subscriberPlates)
          ..where((sp) => sp.plate.equals(plate.toUpperCase())))
        .get();
    for (final sp in matching) {
      final sub = await (select(subscribers)
            ..where((s) =>
                s.id.equals(sp.subscriberId) &
                s.isActive.equals(true) &
                s.endDate.isBiggerOrEqualValue(now) &
                s.subscriberType.equals('monthly')))
          .getSingleOrNull();
      if (sub != null) return sub;
    }
    return null;
  }

  Future<Subscriber?> findActiveDailySubscriberByPlate(String plate) async {
    final matching = await (select(subscriberPlates)
          ..where((sp) => sp.plate.equals(plate.toUpperCase())))
        .get();
    for (final sp in matching) {
      final sub = await (select(subscribers)
            ..where((s) =>
                s.id.equals(sp.subscriberId) &
                s.isActive.equals(true) &
                s.subscriberType.equals('daily')))
          .getSingleOrNull();
      if (sub != null) return sub;
    }
    return null;
  }

  // ─── Large vehicle queries (legacy) ──────────────────────────────────────

  Future<bool> isKnownLargeVehicle(String plate) async {
    final row = await (select(largeVehiclePlates)
          ..where((lv) => lv.plate.equals(plate.toUpperCase()))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> addKnownLargeVehicle(String plate) async {
    final normalised = plate.toUpperCase().trim();
    final exists = await isKnownLargeVehicle(normalised);
    if (!exists) {
      await into(largeVehiclePlates).insert(
        LargeVehiclePlatesCompanion.insert(plate: normalised),
      );
    }
  }

  Future<void> removeKnownLargeVehicle(String plate) =>
      (delete(largeVehiclePlates)
            ..where((lv) => lv.plate.equals(plate.toUpperCase())))
          .go();

  Stream<List<LargeVehiclePlate>> watchKnownLargeVehicles() =>
      (select(largeVehiclePlates)
            ..orderBy([(lv) => OrderingTerm.asc(lv.plate)]))
          .watch();

  // ─── Registered vehicles queries ─────────────────────────────────────────

  /// Returns the registered vehicle record for [plate], or null if unknown.
  Future<RegisteredVehicle?> getRegisteredVehicle(String plate) =>
      (select(registeredVehicles)
            ..where((rv) => rv.plate.equals(plate.toUpperCase()))
            ..limit(1))
          .getSingleOrNull();

  /// Insert or replace a registered vehicle record.
  Future<void> upsertRegisteredVehicle(RegisteredVehiclesCompanion entry) =>
      into(registeredVehicles).insertOnConflictUpdate(entry);

  /// Extends the monthly subscription by 30 days from [base] and saves the fee.
  Future<void> renewMonthlySubscription({
    required String plate,
    required double fee,
  }) async {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 30));
    await (update(registeredVehicles)
          ..where((rv) => rv.plate.equals(plate.toUpperCase())))
        .write(RegisteredVehiclesCompanion(
      subscriptionStartDate: Value(now),
      subscriptionEndDate: Value(endDate),
      monthlyFee: Value(fee),
    ));
  }

  /// Returns registered vehicle plates that contain [rawQuery].
  Future<List<String>> searchRegisteredVehiclePlates(String rawQuery,
      {int limit = 6}) async {
    final q = rawQuery.replaceAll(' ', '');
    if (q.isEmpty) return [];
    final rows = await (select(registeredVehicles)).get();
    return rows
        .map((r) => r.plate)
        .where((p) => p.replaceAll(' ', '').contains(q))
        .take(limit)
        .toList();
  }

  Stream<List<RegisteredVehicle>> watchAllRegisteredVehicles() =>
      (select(registeredVehicles)
            ..orderBy([(rv) => OrderingTerm.asc(rv.plate)]))
          .watch();

  Future<void> deleteRegisteredVehicle(int id) =>
      (delete(registeredVehicles)..where((rv) => rv.id.equals(id))).go();

  Future<bool> updateRegisteredVehicle(RegisteredVehiclesCompanion entry) =>
      update(registeredVehicles).replace(entry);

  Future<bool> hasPaymentRecordsForPlate(String plate) async {
    final rows = await (select(parkingRecords)
          ..where((r) =>
              r.plate.equals(plate.toUpperCase()) &
              r.status.equals('exited'))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }
}

// ─── Connection ──────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'parkmate.db'));
    return NativeDatabase.createInBackground(file);
  });
}
