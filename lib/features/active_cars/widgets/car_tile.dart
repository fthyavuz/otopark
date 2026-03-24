import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../shared/utils/duration_formatter.dart';

class CarTile extends StatefulWidget {
  const CarTile({super.key, required this.record});

  final ParkingRecord record;

  @override
  State<CarTile> createState() => _CarTileState();
}

class _CarTileState extends State<CarTile> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Rebuild every 30 s so elapsed time stays fresh.
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final elapsed = DateTime.now().difference(record.entryTime);
    final entryStr = DateFormat('HH:mm').format(record.entryTime);
    final dateStr = DateFormat('dd.MM.yyyy').format(record.entryTime);
    final isToday = _isToday(record.entryTime);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Left: plate + info ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plate row
                  Row(
                    children: [
                      Text(
                        record.plate,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      if (record.isSubscriber) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ABONMAN',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Entry time
                  Text(
                    isToday
                        ? 'Giriş: $entryStr'
                        : 'Giriş: $dateStr $entryStr',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  // Elapsed time
                  Text(
                    'Süre: ${DurationFormatter.format(elapsed)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _elapsedColor(elapsed),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),

            // ── Right: exit button ──────────────────────────────
            FilledButton.tonal(
              onPressed: () =>
                  context.go('/exit', extra: record.plate),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                foregroundColor: Colors.orange.shade900,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(height: 2),
                  Text('Çıkış', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static Color _elapsedColor(Duration elapsed) {
    if (elapsed.inHours < 2) return Colors.green.shade700;
    if (elapsed.inHours < 4) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
