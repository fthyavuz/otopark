import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/providers/database_provider.dart';
import '../subscriber_dialogs.dart';
import '../subscriber_models.dart';
import 'subscriber_form_sheet.dart';

class SubscriberCard extends ConsumerWidget {
  const SubscriberCard({super.key, required this.item});

  final SubscriberWithPlates item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = item.subscriber;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final fromStr = dateFormat.format(s.startDate);
    final toStr = dateFormat.format(s.endDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: plates + badges ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plates
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: item.plates
                        .map((p) => _PlateBadge(plate: p.plate))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _TypeBadge(type: item.type),
                    const SizedBox(height: 4),
                    if (item.type == SubType.monthly)
                      _StatusBadge(status: item.status),
                    if (item.isFeeDue) ...[
                      const SizedBox(height: 4),
                      _FeeDueBadge(),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notes
            if (s.notes != null && s.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  s.notes!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ),

            // Dates
            Text(
              '$fromStr – $toStr',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 2),

            // Status label
            Text(
              item.statusLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _statusColor(item.status),
              ),
            ),
            const SizedBox(height: 10),

            // ── Action buttons ───────────────────────────────────
            Row(
              children: [
                // Edit
                OutlinedButton.icon(
                  onPressed: () => showSubscriberFormSheet(
                    context,
                    existing: item,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Düzenle'),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6)),
                ),
                const SizedBox(width: 8),
                if (item.type == SubType.monthly && item.isFeeDue)
                  OutlinedButton.icon(
                    onPressed: () => showSubscriberPaymentDialog(
                        context, ref, item),
                    icon: const Icon(Icons.payments_outlined, size: 16),
                    label: const Text('Ücret Al'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6)),
                  ),
                if (item.type == SubType.monthly && item.isFeeDue)
                  const SizedBox(width: 8),
                if (item.type == SubType.monthly)
                  OutlinedButton.icon(
                    onPressed: () => _showRenewDialog(context, ref),
                    icon: const Icon(Icons.autorenew, size: 16),
                    label: const Text('Yenile'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: item.isNearingExpiry
                            ? Colors.orange.shade700
                            : Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6)),
                  ),
                const Spacer(),
                // Delete
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, ref),
                  tooltip: 'Sil',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Renew dialog ──────────────────────────────────────────────────────────

  Future<void> _showRenewDialog(BuildContext context, WidgetRef ref) async {
    // Renew from end date (or today if expired)
    final base = item.subscriber.endDate.isBefore(DateTime.now())
        ? DateTime.now()
        : item.subscriber.endDate;
    final newEndDate = addOneMonth(base);
    final dateFormat = DateFormat('dd.MM.yyyy');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abonmanı Yenile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yeni bitiş tarihi:',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(newEndDate),
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '(${dateFormat.format(item.subscriber.endDate)} tarihinden +1 ay)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('İptal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Onayla')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(databaseProvider)
          .renewSubscriber(item.subscriber.id, newEndDate);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Abonman ${dateFormat.format(newEndDate)} tarihine uzatıldı.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // ─── Delete dialog ─────────────────────────────────────────────────────────

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final plateList =
        item.plates.map((p) => p.plate).join(', ');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber, color: Colors.red, size: 40),
        title: const Text('Abonmanı Sil'),
        content: Text(
          'Bu abonman ve kayıtlı plakalar ($plateList) silinecek.\n\nBu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(databaseProvider)
          .deleteSubscriberWithPlates(item.subscriber.id);
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static Color _statusColor(SubStatus status) {
    switch (status) {
      case SubStatus.active:
        return Colors.green.shade700;
      case SubStatus.expiringSoon:
        return Colors.orange.shade700;
      case SubStatus.expired:
        return Colors.red.shade700;
    }
  }
}

// ─── Small widgets ────────────────────────────────────────────────────────────

class _PlateBadge extends StatelessWidget {
  const _PlateBadge({required this.plate});

  final String plate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        plate,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final SubType type;

  @override
  Widget build(BuildContext context) {
    final isDaily = type == SubType.daily;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDaily ? Colors.teal.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isDaily ? 'GÜNLÜK' : 'AYLIK',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDaily ? Colors.teal.shade800 : Colors.blue.shade800,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SubStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      SubStatus.active => ('AKTİF', Colors.green.shade100, Colors.green.shade800),
      SubStatus.expiringSoon => ('YAKIN BİTİYOR', Colors.orange.shade100, Colors.orange.shade800),
      SubStatus.expired => ('SÜRESİ DOLMUŞ', Colors.red.shade100, Colors.red.shade800),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
    );
  }
}

class _FeeDueBadge extends StatelessWidget {
  const _FeeDueBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payments_outlined,
              size: 11, color: Colors.red.shade700),
          const SizedBox(width: 4),
          Text('ÜCRET BEKLİYOR',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700)),
        ],
      ),
    );
  }
}
