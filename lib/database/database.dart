import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tariffs.dart';
import 'tables/parking_records.dart';
import 'tables/subscribers.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Tariffs,
  ParkingRecords,
  Subscribers,
  SubscriberPlates,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultTariff();
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

  /// Archives the current active tariff and inserts [newTariff] as active.
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

  /// Updates the active tariff in place (no archiving).
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

  /// Marks a car as exited and saves the billing result.
  Future<void> exitCar({
    required int recordId,
    required DateTime exitTime,
    required double calculatedCost,
    required String tariffNameSnapshot,
    required bool isSubscriber,
  }) =>
      (update(parkingRecords)..where((r) => r.id.equals(recordId))).write(
        ParkingRecordsCompanion(
          exitTime: Value(exitTime),
          calculatedCost: Value(calculatedCost),
          tariffNameSnapshot: Value(tariffNameSnapshot),
          isSubscriber: Value(isSubscriber),
          status: const Value('exited'),
        ),
      );

  Future<List<ParkingRecord>> getRecordsByDateRange(
          DateTime from, DateTime to) =>
      (select(parkingRecords)
            ..where((r) =>
                r.exitTime.isBiggerOrEqualValue(from) &
                r.exitTime.isSmallerOrEqualValue(to) &
                r.status.equals('exited')))
          .get();

  // ─── Subscriber queries ───────────────────────────────────────────────────

  Stream<List<Subscriber>> watchAllSubscribers() =>
      (select(subscribers)..orderBy([(s) => OrderingTerm.desc(s.startDate)]))
          .watch();

  Future<int> insertSubscriber(SubscribersCompanion entry) =>
      into(subscribers).insert(entry);

  Future<bool> updateSubscriber(SubscribersCompanion entry) =>
      update(subscribers).replace(entry);

  Future<int> deleteSubscriber(int id) =>
      (delete(subscribers)..where((s) => s.id.equals(id))).go();

  /// Deletes a subscriber and all their plates atomically.
  Future<void> deleteSubscriberWithPlates(int id) async {
    await transaction(() async {
      await (delete(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(id)))
          .go();
      await (delete(subscribers)..where((s) => s.id.equals(id))).go();
    });
  }

  /// Extends the subscription end date (renewal).
  Future<void> renewSubscriber(int id, DateTime newEndDate) =>
      (update(subscribers)..where((s) => s.id.equals(id))).write(
        SubscribersCompanion(
          endDate: Value(newEndDate),
          isActive: const Value(true),
        ),
      );

  /// Replaces all plates for a subscriber inside a transaction.
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

  Future<List<SubscriberPlate>> getPlatesForSubscriber(int subscriberId) =>
      (select(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(subscriberId)))
          .get();

  Stream<List<SubscriberPlate>> watchPlatesForSubscriber(int subscriberId) =>
      (select(subscriberPlates)
            ..where((sp) => sp.subscriberId.equals(subscriberId)))
          .watch();

  Future<int> insertSubscriberPlate(SubscriberPlatesCompanion entry) =>
      into(subscriberPlates).insert(entry);

  Future<int> deleteSubscriberPlate(int plateId) =>
      (delete(subscriberPlates)..where((sp) => sp.id.equals(plateId))).go();

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
                s.endDate.isBiggerOrEqualValue(now)))
          .getSingleOrNull();
      if (sub != null) return sub;
    }
    return null;
  }

  Stream<List<SubscriberPlate>> watchAllSubscriberPlates() =>
      select(subscriberPlates).watch();
}

// ─── Connection ──────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'parkmate.db'));
    return NativeDatabase.createInBackground(file);
  });
}
