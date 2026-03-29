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
  final ParkingBreakdown parkingBreakdown;

  const ReportData({
    required this.records,
    required this.totalTransactions,
    required this.paidTransactions,
    required this.subscriberTransactions,
    required this.totalRevenue,
    this.averageRevenue,
    required this.parkingBreakdown,
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
      parkingBreakdown: ParkingBreakdown.fromRecords(records),
    );
  }

  static const ReportData empty = ReportData(
    records: [],
    totalTransactions: 0,
    paidTransactions: 0,
    subscriberTransactions: 0,
    totalRevenue: 0,
    parkingBreakdown: ParkingBreakdown.empty,
  );
}

// ─── Parking report breakdown ─────────────────────────────────────────────────

class ParkingBreakdown {
  final int normalCount;
  final double normalRevenue;
  final int dailyCount;
  final double dailyRevenue;
  final int monthlyPaymentCount;
  final double monthlyPaymentRevenue;

  const ParkingBreakdown({
    required this.normalCount,
    required this.normalRevenue,
    required this.dailyCount,
    required this.dailyRevenue,
    required this.monthlyPaymentCount,
    required this.monthlyPaymentRevenue,
  });

  double get totalRevenue =>
      normalRevenue + dailyRevenue + monthlyPaymentRevenue;

  factory ParkingBreakdown.fromRecords(List<ParkingRecord> records) {
    final exited = records.where((r) => r.status == 'exited').toList();

    // Monthly payment records: have notes starting with 'Aylık Abonman'
    final monthlyPayments = exited
        .where((r) =>
            r.notes != null && r.notes!.startsWith('Aylık Abonman'))
        .toList();

    // Daily subscriber records
    final daily = exited
        .where((r) =>
            r.isDailySubscriber &&
            !(r.notes != null && r.notes!.startsWith('Aylık Abonman')))
        .toList();

    // Normal paid cars (not subscriber, not daily, not subscription payment)
    final normal = exited
        .where((r) =>
            !r.isSubscriber &&
            !r.isDailySubscriber &&
            !(r.notes != null && r.notes!.startsWith('Aylık Abonman')))
        .toList();

    return ParkingBreakdown(
      normalCount: normal.length,
      normalRevenue:
          normal.fold(0.0, (s, r) => s + (r.calculatedCost ?? 0.0)),
      dailyCount: daily.length,
      dailyRevenue:
          daily.fold(0.0, (s, r) => s + (r.calculatedCost ?? 0.0)),
      monthlyPaymentCount: monthlyPayments.length,
      monthlyPaymentRevenue: monthlyPayments.fold(
          0.0, (s, r) => s + (r.calculatedCost ?? 0.0)),
    );
  }

  static const ParkingBreakdown empty = ParkingBreakdown(
    normalCount: 0,
    normalRevenue: 0,
    dailyCount: 0,
    dailyRevenue: 0,
    monthlyPaymentCount: 0,
    monthlyPaymentRevenue: 0,
  );
}

// ─── Cleaning report data ─────────────────────────────────────────────────────

class CleaningReportData {
  final int interiorCount;
  final double interiorRevenue;
  final int exteriorCount;
  final double exteriorRevenue;
  final int interiorExteriorCount;
  final double interiorExteriorRevenue;
  final int fullCount;
  final double fullRevenue;

  const CleaningReportData({
    required this.interiorCount,
    required this.interiorRevenue,
    required this.exteriorCount,
    required this.exteriorRevenue,
    required this.interiorExteriorCount,
    required this.interiorExteriorRevenue,
    required this.fullCount,
    required this.fullRevenue,
  });

  double get totalRevenue =>
      interiorRevenue + exteriorRevenue + interiorExteriorRevenue + fullRevenue;

  int get totalCount =>
      interiorCount + exteriorCount + interiorExteriorCount + fullCount;

  factory CleaningReportData.fromRecords(List<CleaningRecord> records) {
    double sumFor(String type) => records
        .where((r) => r.serviceType == type)
        .fold(0.0, (s, r) => s + r.finalCost);
    int countFor(String type) =>
        records.where((r) => r.serviceType == type).length;

    return CleaningReportData(
      interiorCount: countFor('interior'),
      interiorRevenue: sumFor('interior'),
      exteriorCount: countFor('exterior'),
      exteriorRevenue: sumFor('exterior'),
      interiorExteriorCount: countFor('interior_exterior'),
      interiorExteriorRevenue: sumFor('interior_exterior'),
      fullCount: countFor('full'),
      fullRevenue: sumFor('full'),
    );
  }

  static const CleaningReportData empty = CleaningReportData(
    interiorCount: 0,
    interiorRevenue: 0,
    exteriorCount: 0,
    exteriorRevenue: 0,
    interiorExteriorCount: 0,
    interiorExteriorRevenue: 0,
    fullCount: 0,
    fullRevenue: 0,
  );
}
