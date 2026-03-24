import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/database_provider.dart';

final insideCarsCountProvider = StreamProvider<int>((ref) {
  return ref.watch(databaseProvider).watchInsideCarsCount();
});

final todayRevenueProvider = StreamProvider<double>((ref) {
  return ref.watch(databaseProvider).watchTodayRevenue();
});
