import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';

final allTariffsProvider = StreamProvider<List<Tariff>>((ref) {
  return ref.watch(databaseProvider).watchAllTariffs();
});

final activeTariffProvider = StreamProvider<Tariff?>((ref) {
  return ref.watch(databaseProvider).watchActiveTariff();
});
