import 'package:drift/drift.dart';

/// Central registry of all vehicles that have ever entered the lot.
/// On first entry the user registers the vehicle type and subscription.
/// Subsequent entries use the saved data automatically.
class RegisteredVehicles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Normalised uppercase plate — unique per vehicle.
  TextColumn get plate => text().withLength(min: 2, max: 20)();

  /// 'normal' | 'large'
  TextColumn get vehicleType =>
      text().withDefault(const Constant('normal'))();

  /// 'none' | 'daily' | 'monthly'
  TextColumn get subscriptionType =>
      text().withDefault(const Constant('none'))();

  /// When the current monthly subscription period started.
  DateTimeColumn get subscriptionStartDate => dateTime().nullable()();

  /// When the current monthly subscription period ends (start + 30 days).
  DateTimeColumn get subscriptionEndDate => dateTime().nullable()();

  /// Per-day fee for daily subscribers.
  RealColumn get dailyFee => real().withDefault(const Constant(150.0))();

  /// Monthly fee amount (loaded from tariff at registration/renewal).
  RealColumn get monthlyFee => real().withDefault(const Constant(0.0))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {plate}
      ];
}
