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

  Future<Tariff?> getActiveTariff() =>
      (select(tariffs)..where((t) => t.isActive.equals(true))..limit(1))
          .getSingleOrNull();

  Future<int> insertTariff(TariffsCompanion entry) =>
      into(tariffs).insert(entry);

  Future<bool> updateTariff(TariffsCompanion entry) =>
      update(tariffs).replace(entry);

  Future<int> deactivateTariff(int id) => (update(tariffs)
        ..where((t) => t.id.equals(id)))
      .write(TariffsCompanion(
        isActive: const Value(false),
        validTo: Value(DateTime.now()),
      ));

  // ─── Parking record queries ───────────────────────────────────────────────

  Stream<List<ParkingRecord>> watchInsideCars() =>
      (select(parkingRecords)
            ..where((r) => r.status.equals('inside'))
            ..orderBy([(r) => OrderingTerm.asc(r.entryTime)]))
          .watch();

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
      (select(subscribers)
            ..orderBy([(s) => OrderingTerm.desc(s.startDate)]))
          .watch();

  Future<int> insertSubscriber(SubscribersCompanion entry) =>
      into(subscribers).insert(entry);

  Future<bool> updateSubscriber(SubscribersCompanion entry) =>
      update(subscribers).replace(entry);

  Future<List<SubscriberPlate>> getPlatesForSubscriber(int subscriberId) =>
      (select(subscriberPlates)
            ..where((p) => p.subscriberId.equals(subscriberId)))
          .get();

  Stream<List<SubscriberPlate>> watchPlatesForSubscriber(int subscriberId) =>
      (select(subscriberPlates)
            ..where((p) => p.subscriberId.equals(subscriberId)))
          .watch();

  Future<int> insertSubscriberPlate(SubscriberPlatesCompanion entry) =>
      into(subscriberPlates).insert(entry);

  Future<int> deleteSubscriberPlate(int plateId) =>
      (delete(subscriberPlates)
            ..where((p) => p.id.equals(plateId)))
          .go();

  /// Returns the active subscriber for a given plate, or null.
  Future<Subscriber?> findActiveSubscriberByPlate(String plate) async {
    final now = DateTime.now();
    final matchingPlates = await (select(subscriberPlates)
          ..where((p) => p.plate.equals(plate.toUpperCase())))
        .get();

    for (final sp in matchingPlates) {
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
