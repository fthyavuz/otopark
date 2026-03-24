import 'package:drift/drift.dart';

class Subscribers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get monthlyFee => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class SubscriberPlates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subscriberId => integer().references(Subscribers, #id)();
  TextColumn get plate => text().withLength(min: 2, max: 20)();
}
