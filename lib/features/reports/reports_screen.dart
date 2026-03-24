import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../active_cars/active_cars_providers.dart';
import 'reports_models.dart';
import 'reports_providers.dart';
import 'widgets/report_stats_grid.dart';
import 'widgets/transaction_tile.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportPeriod _period = ReportPeriod.today;

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(reportDataProvider(_period));
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raporlar'),
        actions: [
          // Shortcut to tariff history
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
            child: isTablet
                ? SegmentedButton<ReportPeriod>(
                    segments: ReportPeriod.values
                        .map((p) => ButtonSegment<ReportPeriod>(
                              value: p,
                              label: Text(p.label),
                            ))
                        .toList(),
                    selected: {_period},
                    onSelectionChanged: (s) =>
                        setState(() => _period = s.first),
                  )
                : _PeriodButtonRow(
                    selected: _period,
                    onChanged: (p) => setState(() => _period = p),
                  ),
          ),

          // ── Date range subtitle ───────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _period.rangeLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),

          // ── Content ───────────────────────────────────────────
          Expanded(
            child: dataAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (data) => _ReportBody(
                data: data,
                period: _period,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Period button row (phone) ────────────────────────────────────────────────

class _PeriodButtonRow extends StatelessWidget {
  const _PeriodButtonRow({
    required this.selected,
    required this.onChanged,
  });

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ReportPeriod.values
            .map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(p.label),
                    selected: selected == p,
                    onSelected: (_) => onChanged(p),
                    showCheckmark: false,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ─── Report body ──────────────────────────────────────────────────────────────

class _ReportBody extends ConsumerWidget {
  const _ReportBody({required this.data, required this.period});

  final ReportData data;
  final ReportPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        // ── Stats grid ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: ReportStatsGrid(data: data),
        ),

        // ── Currently inside (today only) ───────────────────────
        if (period == ReportPeriod.today)
          SliverToBoxAdapter(
            child: _InsideNowBanner(),
          ),

        // ── Transactions header ─────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Text(
                  'İşlemler',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${data.totalTransactions}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Transaction list ────────────────────────────────────
        if (data.records.isEmpty)
          const SliverFillRemaining(
            child: _EmptyTransactions(),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => TransactionTile(record: data.records[i]),
              childCount: data.records.length,
            ),
          ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
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
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
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

// ─── Active tariff info widget ────────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Bu dönem için kayıt yok',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            'Araç çıkışları burada görünecek.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
