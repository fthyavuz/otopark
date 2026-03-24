import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';

final insideCarsProvider = StreamProvider<List<ParkingRecord>>((ref) {
  return ref.watch(databaseProvider).watchInsideCars();
});

/// Ticks every 30 seconds so elapsed-time widgets stay current.
final clockTickProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(const Duration(seconds: 30));
  }
});
