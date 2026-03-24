import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: () => context.go('/tariff'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Stats row ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'İçerideki Araç',
                    value: '—',
                    icon: Icons.local_parking,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Bugünkü Gelir',
                    value: '— ₺',
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
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
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
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.bodySmall),
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
