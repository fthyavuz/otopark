import 'package:drift/drift.dart';

import 'tariffs.dart';

enum ParkingStatus { inside, exited }

class ParkingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get plate => text().withLength(min: 2, max: 20)();
  DateTimeColumn get entryTime => dateTime()();
  DateTimeColumn get exitTime => dateTime().nullable()();

  /// The tariff that was active at entry time — used for accurate billing.
  IntColumn get tariffId => integer().nullable().references(Tariffs, #id)();

  /// Snapshot of the tariff name at time of exit — for historical records.
  TextColumn get tariffNameSnapshot => text().nullable()();

  RealColumn get calculatedCost => real().nullable()();
  BoolColumn get isSubscriber => boolean().withDefault(const Constant(false))();

  /// 'inside' or 'exited'
  TextColumn get status => text().withDefault(const Constant('inside'))();

  TextColumn get notes => text().nullable()();
}
