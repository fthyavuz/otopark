import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/database_provider.dart';
import '../reports/reports_models.dart';

final cleaningReportDataProvider =
    StreamProvider.family<CleaningReportData, (DateTime, DateTime)>((ref, range) {
  final db = ref.watch(databaseProvider);
  return db
      .watchCleaningRecordsByDateRange(range.$1, range.$2)
      .map(CleaningReportData.fromRecords);
});

final todayCleaningRevenueProvider = StreamProvider<double>((ref) {
  return ref.watch(databaseProvider).watchTodayCleaningRevenue();
});
