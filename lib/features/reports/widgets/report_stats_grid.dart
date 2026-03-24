import 'package:flutter/material.dart';

import '../../../shared/utils/currency_formatter.dart';
import '../reports_models.dart';

class ReportStatsGrid extends StatelessWidget {
  const ReportStatsGrid({super.key, required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Toplam Gelir',
                  value: CurrencyFormatter.format(data.totalRevenue),
                  icon: Icons.payments_outlined,
                  color: Colors.green.shade700,
                  large: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: 'Toplam Araç',
                  value: '${data.totalTransactions}',
                  icon: Icons.directions_car_outlined,
                  color: Colors.blue.shade700,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Abonman',
                  value: '${data.subscriberTransactions}',
                  icon: Icons.card_membership_outlined,
                  color: Colors.teal.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: 'Ort. Ücret',
                  value: data.averageRevenue != null
                      ? CurrencyFormatter.format(data.averageRevenue!)
                      : '—',
                  icon: Icons.calculate_outlined,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ],
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
    this.large = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: large ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
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
