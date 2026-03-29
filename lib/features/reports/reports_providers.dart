import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/database_provider.dart';
import 'reports_models.dart';

/// Reactive report data — auto-updates when any exit is recorded.
final reportDataProvider =
    StreamProvider.family<ReportData, ReportPeriod>((ref, period) {
  final db = ref.watch(databaseProvider);
  final (from, to) = period.dateRange;
  return db
      .watchRecordsByDateRange(from, to)
      .map(ReportData.fromRecords);
});

/// Custom date range report data — used when user picks a specific range.
final customReportDataProvider =
    StreamProvider.family<ReportData, (DateTime, DateTime)>((ref, range) {
  final db = ref.watch(databaseProvider);
  return db
      .watchRecordsByDateRange(range.$1, range.$2)
      .map(ReportData.fromRecords);
});

final cleaningReportDataProvider =
    StreamProvider.family<CleaningReportData, ReportPeriod>((ref, period) {
  final db = ref.watch(databaseProvider);
  final (from, to) = period.dateRange;
  return db
      .watchCleaningRecordsByDateRange(from, to)
      .map(CleaningReportData.fromRecords);
});

final customCleaningReportDataProvider =
    StreamProvider.family<CleaningReportData, (DateTime, DateTime)>((ref, range) {
  final db = ref.watch(databaseProvider);
  return db
      .watchCleaningRecordsByDateRange(range.$1, range.$2)
      .map(CleaningReportData.fromRecords);
});
