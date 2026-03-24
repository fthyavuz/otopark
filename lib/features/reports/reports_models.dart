import 'package:intl/intl.dart';

import '../../database/database.dart';

// ─── Period enum ──────────────────────────────────────────────────────────────

enum ReportPeriod { today, week, month, year }

extension ReportPeriodExt on ReportPeriod {
  String get label => switch (this) {
        ReportPeriod.today => 'Bugün',
        ReportPeriod.week => 'Bu Hafta',
        ReportPeriod.month => 'Bu Ay',
        ReportPeriod.year => 'Bu Yıl',
      };

  /// [from, to] date range for this period (inclusive).
  (DateTime, DateTime) get dateRange {
    final now = DateTime.now();
    switch (this) {
      case ReportPeriod.today:
        final start = DateTime(now.year, now.month, now.day);
        return (start, start.add(const Duration(days: 1)));

      case ReportPeriod.week:
        // Week starts on Monday (weekday == 1)
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final start = DateTime(monday.year, monday.month, monday.day);
        return (start, start.add(const Duration(days: 7)));

      case ReportPeriod.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        return (start, end);

      case ReportPeriod.year:
        return (DateTime(now.year, 1, 1), DateTime(now.year + 1, 1, 1));
    }
  }

  /// Human-readable date range label in Turkish.
  String get rangeLabel {
    final now = DateTime.now();
    switch (this) {
      case ReportPeriod.today:
        return DateFormat('d MMMM yyyy', 'tr_TR').format(now);

      case ReportPeriod.week:
        final (from, to) = dateRange;
        final sun = to.subtract(const Duration(days: 1));
        if (from.month == sun.month) {
          return '${from.day}–${sun.day} ${DateFormat('MMMM yyyy', 'tr_TR').format(from)}';
        }
        return '${from.day} ${DateFormat('MMM', 'tr_TR').format(from)} – '
            '${sun.day} ${DateFormat('MMM yyyy', 'tr_TR').format(sun)}';

      case ReportPeriod.month:
        return DateFormat('MMMM yyyy', 'tr_TR').format(now);

      case ReportPeriod.year:
        return '${now.year}';
    }
  }
}

// ─── Report summary ───────────────────────────────────────────────────────────

class ReportData {
  final List<ParkingRecord> records;
  final int totalTransactions;
  final int paidTransactions;
  final int subscriberTransactions;
  final double totalRevenue;
  final double? averageRevenue; // null when no paid transactions

  const ReportData({
    required this.records,
    required this.totalTransactions,
    required this.paidTransactions,
    required this.subscriberTransactions,
    required this.totalRevenue,
    this.averageRevenue,
  });

  factory ReportData.fromRecords(List<ParkingRecord> records) {
    final paid = records.where((r) => !r.isSubscriber).toList();
    final subCount = records.where((r) => r.isSubscriber).length;
    final revenue =
        paid.fold(0.0, (sum, r) => sum + (r.calculatedCost ?? 0.0));

    return ReportData(
      records: records, // already sorted desc by DB query
      totalTransactions: records.length,
      paidTransactions: paid.length,
      subscriberTransactions: subCount,
      totalRevenue: revenue,
      averageRevenue: paid.isNotEmpty ? revenue / paid.length : null,
    );
  }

  static const ReportData empty = ReportData(
    records: [],
    totalTransactions: 0,
    paidTransactions: 0,
    subscriberTransactions: 0,
    totalRevenue: 0,
  );
}
