import 'package:drift/drift.dart';

class CleaningRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get plate => text().withLength(min: 2, max: 20)();

  /// 'interior' | 'exterior' | 'interior_exterior' | 'full'
  TextColumn get serviceType => text()();

  /// Base price before surcharges/discounts (from settings at time of service)
  RealColumn get baseCost => real()();

  /// Final amount actually charged
  RealColumn get finalCost => real()();

  /// Discount percentage applied (0.0 = no discount)
  RealColumn get discountPercent => real().withDefault(const Constant(0.0))();

  BoolColumn get isLargeVehicle => boolean().withDefault(const Constant(false))();

  /// True if the car was inside the parking lot at time of cleaning
  BoolColumn get wasParkingCar => boolean().withDefault(const Constant(false))();

  /// 'cleaning' = in progress / not yet paid | 'cleaned' = completed and paid
  TextColumn get status => text().withDefault(const Constant('cleaned'))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
