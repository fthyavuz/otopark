import 'package:drift/drift.dart';

/// Stores plates that are known to be large vehicles.
/// Once a plate is marked large, it is automatically recognised on future entries.
class LargeVehiclePlates extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Normalised uppercase plate string — unique per plate.
  TextColumn get plate => text().withLength(min: 2, max: 20)();
}
