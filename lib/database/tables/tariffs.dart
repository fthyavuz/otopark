import 'package:drift/drift.dart';

/// Tariff brackets are stored as a JSON string in the database.
/// Each bracket: {"upToMinutes": 60, "price": 100.0}
/// The final bracket acts as the full-day cap price.
class Tariffs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// JSON array of TariffBracket objects sorted by upToMinutes ascending.
  /// Last entry with upToMinutes = null means "full day" price.
  TextColumn get bracketsJson => text()();

  RealColumn get fullDayPrice => real()();
  RealColumn get monthlyPrice => real()();
  RealColumn get dailySubscriptionPrice => real().withDefault(const Constant(150.0))();

  DateTimeColumn get validFrom => dateTime()();
  DateTimeColumn get validTo => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
