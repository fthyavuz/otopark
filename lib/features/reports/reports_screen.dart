import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/providers/settings_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../active_cars/active_cars_providers.dart';
import 'reports_models.dart';
import 'reports_providers.dart';
import 'widgets/transaction_tile.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportPeriod? _period = ReportPeriod.today;
  DateTime? _customFrom;
  DateTime? _customTo;

  bool get _isCustom => _period == null;

  String get _rangeLabel {
    if (!_isCustom) return _period!.rangeLabel;
    if (_customFrom == null || _customTo == null) return 'Tarih seçin';
    final fmt = DateFormat('d MMM yyyy', 'tr_TR');
    final to = _customTo!.subtract(const Duration(days: 1));
    return '${fmt.format(_customFrom!)} – ${fmt.format(to)}';
  }

  AsyncValue<ReportData> get _dataAsync {
    if (!_isCustom) return ref.watch(reportDataProvider(_period!));
    if (_customFrom == null || _customTo == null) {
      return const AsyncValue.data(ReportData.empty);
    }
    return ref.watch(customReportDataProvider((_customFrom!, _customTo!)));
  }

  AsyncValue<CleaningReportData> get _cleaningAsync {
    if (!_isCustom) return ref.watch(cleaningReportDataProvider(_period!));
    if (_customFrom == null || _customTo == null) {
      return const AsyncValue.data(CleaningReportData.empty);
    }
    return ref.watch(customCleaningReportDataProvider((_customFrom!, _customTo!)));
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _customFrom != null && _customTo != null
          ? DateTimeRange(
              start: _customFrom!,
              end: _customTo!.subtract(const Duration(days: 1)))
          : DateTimeRange(
              start: DateTime(now.year, now.month, now.day),
              end: DateTime(now.year, now.month, now.day)),
      locale: const Locale('tr', 'TR'),
      helpText: 'Tarih Aralığı Seçin',
      cancelText: 'İptal',
      confirmText: 'Tamam',
    );
    if (picked != null) {
      setState(() {
        _period = null;
        _customFrom = picked.start;
        // +1 day so the end date is inclusive in the DB query
        _customTo = picked.end.add(const Duration(days: 1));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = _dataAsync;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raporlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.price_change_outlined),
            tooltip: 'Tarife Geçmişi',
            onPressed: () => context.push('/tariff'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Period selector ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: _PeriodButtonRow(
              selected: _period,
              onChanged: (p) => setState(() {
                _period = p;
                _customFrom = null;
                _customTo = null;
              }),
              onCustomTap: _pickCustomRange,
            ),
          ),

          // ── Date range subtitle ───────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: _isCustom ? _pickCustomRange : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _rangeLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  if (_isCustom) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.edit_calendar,
                        size: 14, color: Colors.grey.shade500),
                  ],
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────
          Expanded(
            child: dataAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (parkingData) {
                final cleaningData =
                    _cleaningAsync.value ?? CleaningReportData.empty;
                final settings = ref.read(cleaningSettingsProvider);
                final ratio = settings.parkingShareRatio;
                final parkingSettlement =
                    parkingData.totalRevenue + ratio * cleaningData.totalRevenue;
                final cleaningSettlement =
                    (1 - ratio) * cleaningData.totalRevenue;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // ── Two summary boxes ────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _ParkingBox(data: parkingData)),
                          const SizedBox(width: 8),
                          Expanded(child: _CleaningBox(data: cleaningData)),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Settlement section ───────────────────────
                      Card(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Text('Gün Sonu Kasa Dağılımı',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              // Row 1: Otopark Kasa | Temizlik Komisyon Kasa
                              Row(
                                children: [
                                  Expanded(
                                    child: _SettlementTile(
                                      label: 'Otopark Kasa',
                                      subtitle: 'Sadece park geliri',
                                      amount: parkingData.totalRevenue,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _SettlementTile(
                                      label: 'Temizlik Komisyon Kasa',
                                      subtitle:
                                          '%${(ratio * 100).toStringAsFixed(0)} temizlik komisyonu',
                                      amount: ratio * cleaningData.totalRevenue,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Row 2: Temizlik İşletmeci Kasa (full width)
                              _SettlementTile(
                                label: 'Temizlik İşletmeci Kasa',
                                subtitle:
                                    '%${((1 - ratio) * 100).toStringAsFixed(0)} temizlik geliri',
                                amount: cleaningSettlement,
                                color: Colors.teal,
                              ),
                              const Divider(height: 20),
                              // Otopark Toplamı
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Otopark Toplamı',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(
                                    CurrencyFormatter.format(parkingSettlement),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Currently inside (today only) ────────────
                      if (_period == ReportPeriod.today)
                        _InsideNowBanner(),

                      const SizedBox(height: 4),

                      // ── Parking transaction list ─────────────────
                      if (parkingData.records.isNotEmpty)
                        ...parkingData.records
                            .map((r) => TransactionTile(record: r)),
                      if (parkingData.records.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Bu dönemde işlem yok.',
                              style: TextStyle(color: Colors.grey)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Period button row ────────────────────────────────────────────────────────

class _PeriodButtonRow extends StatelessWidget {
  const _PeriodButtonRow({
    required this.selected,
    required this.onChanged,
    required this.onCustomTap,
  });

  final ReportPeriod? selected;
  final ValueChanged<ReportPeriod> onChanged;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...ReportPeriod.values.map((p) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(p.label),
                  selected: selected == p,
                  onSelected: (_) => onChanged(p),
                  showCheckmark: false,
                ),
              )),
          FilterChip(
            label: const Text('Özel'),
            selected: selected == null,
            onSelected: (_) => onCustomTap(),
            showCheckmark: false,
            avatar: const Icon(Icons.date_range, size: 16),
          ),
        ],
      ),
    );
  }
}

// ─── Currently inside banner ──────────────────────────────────────────────────

class _InsideNowBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(insideCarsProvider);

    return countAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (cars) {
        if (cars.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => context.go('/active-cars'),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.local_parking,
                    color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Şu an ${cars.length} araç içeride',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.blue.shade400),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Parking summary box ──────────────────────────────────────────────────────

class _ParkingBox extends StatelessWidget {
  const _ParkingBox({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final b = data.parkingBreakdown;
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.local_parking, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 6),
              Text('Park Geliri',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800)),
            ]),
            const SizedBox(height: 8),
            _row('Normal Araç', b.normalCount, b.normalRevenue),
            _row('Günlük Abone', b.dailyCount, b.dailyRevenue),
            _row('Aylık Abonman', b.monthlyPaymentCount,
                b.monthlyPaymentRevenue),
            const Divider(height: 12),
            _totalRow(b.totalRevenue, Colors.blue.shade700),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, int count, double revenue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text('$label ($count)',
                style: const TextStyle(fontSize: 11, color: Colors.black87),
                overflow: TextOverflow.ellipsis),
          ),
          Text(CurrencyFormatter.format(revenue),
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _totalRow(double total, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Toplam',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        Text(CurrencyFormatter.format(total),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 14)),
      ],
    );
  }
}

// ─── Cleaning summary box ─────────────────────────────────────────────────────

class _CleaningBox extends StatelessWidget {
  const _CleaningBox({required this.data});

  final CleaningReportData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.local_car_wash,
                  color: Colors.teal.shade700, size: 18),
              const SizedBox(width: 6),
              Text('Temizlik Geliri',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800)),
            ]),
            const SizedBox(height: 8),
            _row('İç', data.interiorCount, data.interiorRevenue),
            _row('Dış', data.exteriorCount, data.exteriorRevenue),
            _row('İç+Dış', data.interiorExteriorCount,
                data.interiorExteriorRevenue),
            _row('Tam', data.fullCount, data.fullRevenue),
            const Divider(height: 12),
            _totalRow(data.totalRevenue, Colors.teal.shade700),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, int count, double revenue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label ($count)',
              style: const TextStyle(fontSize: 11, color: Colors.black87)),
          Text(CurrencyFormatter.format(revenue),
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _totalRow(double total, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Toplam',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        Text(CurrencyFormatter.format(total),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 14)),
      ],
    );
  }
}

// ─── Settlement tile ──────────────────────────────────────────────────────────

class _SettlementTile extends StatelessWidget {
  const _SettlementTile({
    required this.label,
    required this.subtitle,
    required this.amount,
    required this.color,
  });

  final String label;
  final String subtitle;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 10, color: color.withValues(alpha: 0.7))),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              CurrencyFormatter.format(amount),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
