import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/utils/duration_formatter.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.record});

  final ParkingRecord record;

  static bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final exitTime = record.exitTime;
    final entryIsToday = _isToday(record.entryTime);

    final entryStr = entryIsToday
        ? DateFormat('HH:mm').format(record.entryTime)
        : DateFormat('dd.MM HH:mm').format(record.entryTime);
    final exitStr =
        exitTime != null ? DateFormat('HH:mm').format(exitTime) : '—';

    final duration = exitTime != null
        ? DurationFormatter.format(exitTime.difference(record.entryTime))
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // ── Left: plate + time range ───────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.plate,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$entryStr → $exitStr  ·  $duration',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              // ── Right: cost or subscriber badge ────────────────
              if (record.isSubscriber)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ABONMAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                )
              else
                Text(
                  CurrencyFormatter.format(record.calculatedCost ?? 0),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
