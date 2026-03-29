import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import 'cleaning_models.dart';

// ─── Filter enum ──────────────────────────────────────────────────────────────

enum _CleaningFilter { today, yesterday, week, month }

extension _CleaningFilterExt on _CleaningFilter {
  String get label => switch (this) {
        _CleaningFilter.today => 'Bugün',
        _CleaningFilter.yesterday => 'Dün',
        _CleaningFilter.week => 'Son 7 Gün',
        _CleaningFilter.month => 'Bu Ay',
      };

  (DateTime, DateTime) get dateRange {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (this) {
      case _CleaningFilter.today:
        return (today, today.add(const Duration(days: 1)));
      case _CleaningFilter.yesterday:
        final yest = today.subtract(const Duration(days: 1));
        return (yest, today);
      case _CleaningFilter.week:
        return (today.subtract(const Duration(days: 6)), today.add(const Duration(days: 1)));
      case _CleaningFilter.month:
        return (DateTime(now.year, now.month, 1), DateTime(now.year, now.month + 1, 1));
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final _cleaningListProvider =
    StreamProvider.family<List<CleaningRecord>, (DateTime, DateTime)>(
        (ref, range) {
  return ref
      .watch(databaseProvider)
      .watchCleaningRecordsByDateRange(range.$1, range.$2);
});

// ─── Screen ───────────────────────────────────────────────────────────────────

class CleaningListScreen extends ConsumerStatefulWidget {
  const CleaningListScreen({super.key});

  @override
  ConsumerState<CleaningListScreen> createState() => _CleaningListScreenState();
}

class _CleaningListScreenState extends ConsumerState<CleaningListScreen> {
  _CleaningFilter _filter = _CleaningFilter.today;

  @override
  Widget build(BuildContext context) {
    final range = _filter.dateRange;
    final recordsAsync = ref.watch(_cleaningListProvider(range));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temizlik Listesi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ── Filter chips ─────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: _CleaningFilter.values
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f.label),
                          selected: _filter == f,
                          selectedColor: Colors.teal.shade100,
                          checkmarkColor: Colors.teal.shade800,
                          onSelected: (_) => setState(() => _filter = f),
                          showCheckmark: true,
                        ),
                      ))
                  .toList(),
            ),
          ),

          // ── List ─────────────────────────────────────────────
          Expanded(
            child: recordsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_car_wash,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('${_filter.label} için kayıt yok.',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // Summary bar
                final total = records.fold(0.0, (s, r) => s + r.finalCost);
                return Column(
                  children: [
                    _SummaryBar(count: records.length, total: total),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: records.length,
                        itemBuilder: (_, i) =>
                            _CleaningTile(record: records[i]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary bar ─────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.count, required this.total});

  final int count;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$count araç temizlendi',
              style: TextStyle(
                  color: Colors.teal.shade800, fontWeight: FontWeight.w600)),
          Text(CurrencyFormatter.format(total),
              style: TextStyle(
                  color: Colors.teal.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────────────────────

class _CleaningTile extends StatelessWidget {
  const _CleaningTile({required this.record});

  final CleaningRecord record;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('HH:mm', 'tr_TR');
    final serviceLabel =
        CleaningServiceType.fromValue(record.serviceType).displayName;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: record.isLargeVehicle
              ? Colors.orange.shade100
              : Colors.teal.shade50,
          child: Icon(
            record.isLargeVehicle ? Icons.local_shipping : Icons.local_car_wash,
            color: record.isLargeVehicle
                ? Colors.orange.shade700
                : Colors.teal.shade700,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Text(record.plate,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(width: 8),
            Text(fmt.format(record.createdAt),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.normal)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceLabel,
                style: const TextStyle(fontSize: 12)),
            if (record.notes != null && record.notes!.isNotEmpty)
              Text(record.notes!,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic)),
            Wrap(
              spacing: 4,
              children: [
                if (record.wasParkingCar)
                  _badge('Otopark', Colors.blue.shade100, Colors.blue.shade800),
                if (record.discountPercent > 0)
                  _badge(
                      '%${record.discountPercent.toStringAsFixed(0)} indirim',
                      Colors.green.shade100,
                      Colors.green.shade800),
              ],
            ),
          ],
        ),
        trailing: Text(
          CurrencyFormatter.format(record.finalCost),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.teal.shade700),
        ),
        isThreeLine: record.notes != null && record.notes!.isNotEmpty,
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: fg)),
      );
}
