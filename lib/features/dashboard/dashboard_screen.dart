import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/utils/currency_formatter.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(insideCarsCountProvider);
    final revenueAsync = ref.watch(todayRevenueProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateFormat('dd MMMM yyyy', 'tr_TR').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ParkMate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(today,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.price_change_outlined),
            tooltip: 'Tarife',
            onPressed: () => context.go('/tariff'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Stats row ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'İçerideki Araç',
                    value: countAsync.when(
                      loading: () => '...',
                      error: (_, __) => '?',
                      data: (n) => '$n',
                    ),
                    icon: Icons.local_parking,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Bugünkü Gelir',
                    value: revenueAsync.when(
                      loading: () => '...',
                      error: (_, __) => '?',
                      data: (r) => CurrencyFormatter.format(r),
                    ),
                    icon: Icons.payments_outlined,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Quick actions ──────────────────────────────────
            Text('Hızlı İşlemler',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.count(
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 600 ? 3 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _ActionCard(
                    label: 'Araç Girişi',
                    icon: Icons.add_circle_outline,
                    color: Colors.green,
                    onTap: () => context.go('/entry'),
                  ),
                  _ActionCard(
                    label: 'Araç Çıkışı',
                    icon: Icons.remove_circle_outline,
                    color: Colors.orange,
                    onTap: () => context.go('/exit'),
                  ),
                  _ActionCard(
                    label: 'İçerideki Araçlar',
                    icon: Icons.format_list_bulleted,
                    color: Colors.blue,
                    badge: countAsync.value,
                    onTap: () => context.go('/active-cars'),
                  ),
                  _ActionCard(
                    label: 'Raporlar',
                    icon: Icons.bar_chart,
                    color: Colors.purple,
                    onTap: () => context.go('/reports'),
                  ),
                  _ActionCard(
                    label: 'Abonmanlar',
                    icon: Icons.card_membership,
                    color: Colors.teal,
                    onTap: () => context.go('/subscribers'),
                  ),
                  _ActionCard(
                    label: 'Tarife',
                    icon: Icons.price_change_outlined,
                    color: Colors.brown,
                    onTap: () => context.go('/tariff'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action card ──────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 36),
                    const SizedBox(height: 8),
                    Text(label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
              if (badge != null && badge! > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text('$badge',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
