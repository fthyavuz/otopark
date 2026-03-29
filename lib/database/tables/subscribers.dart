import 'package:drift/drift.dart';

class Subscribers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get monthlyFee => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// 'monthly' or 'daily'
  TextColumn get subscriberType =>
      text().withDefault(const Constant('monthly'))();

  /// Fee charged per day for daily subscribers (null = use default 150).
  RealColumn get dailyFee => real().nullable()();

  /// When the monthly fee was last paid until (set to endDate at payment).
  DateTimeColumn get feePaidUntil => dateTime().nullable()();

  /// If set and in the future, don't prompt for payment.
  DateTimeColumn get paymentSnoozedUntil => dateTime().nullable()();
}

class SubscriberPlates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subscriberId => integer().references(Subscribers, #id)();
  TextColumn get plate => text().withLength(min: 2, max: 20)();
}
