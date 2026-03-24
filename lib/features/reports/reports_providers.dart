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
