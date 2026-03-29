import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../shared/providers/database_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import 'subscriber_models.dart';

enum _PaymentChoice { paid, postpone, snoozeEndOfMonth }

/// Shows a dialog asking whether the monthly fee was collected.
/// - "TAHSİL EDİLDİ": records payment in reports and marks feePaidUntil.
/// - "Ay Sonuna Ertele": snoozes the reminder until the last week of the contract.
/// - "Sonra Hatırla": does nothing (will ask again on next screen open).
Future<void> showSubscriberPaymentDialog(
  BuildContext context,
  WidgetRef ref,
  SubscriberWithPlates item,
) async {
  final db = ref.read(databaseProvider);
  final sub = item.subscriber;
  final dateFormat = DateFormat('dd.MM.yyyy');

  final result = await showDialog<_PaymentChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.payments_outlined, color: Colors.blue, size: 36),
      title: const Text('Abonman Ücreti Bekleniyor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: item.plates
                .map((p) => Chip(
                      label: Text(p.plate,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2)),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          if (sub.notes != null && sub.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(sub.notes!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          ],
          const SizedBox(height: 10),
          Text(
            'Dönem: ${dateFormat.format(sub.startDate)} – ${dateFormat.format(sub.endDate)}',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(sub.monthlyFee),
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Bu dönem için ücret tahsil edildi mi?'),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('TAHSİL EDİLDİ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () =>
                    Navigator.of(ctx).pop(_PaymentChoice.paid),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                icon: const Icon(Icons.schedule, size: 18),
                label: const Text('Ay Sonuna Ertele'),
                onPressed: () =>
                    Navigator.of(ctx).pop(_PaymentChoice.snoozeEndOfMonth),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(_PaymentChoice.postpone),
                child: const Text('Sonra Hatırla'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  if (result == null || !context.mounted) return;

  if (result == _PaymentChoice.paid) {
    final firstPlate =
        item.plates.isNotEmpty ? item.plates.first.plate : 'ABONMAN';
    await db.insertSubscriptionPaymentRecord(
      plate: firstPlate,
      amount: sub.monthlyFee,
      notes:
          'Aylık Abonman Ödemesi (${dateFormat.format(sub.startDate)} – ${dateFormat.format(sub.endDate)})',
    );
    await db.markSubscriptionFeePaid(sub.id, sub.endDate);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${CurrencyFormatter.format(sub.monthlyFee)} tahsil edildi ve rapora eklendi.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } else if (result == _PaymentChoice.snoozeEndOfMonth) {
    final lastWeekStart = sub.endDate.subtract(const Duration(days: 7));
    final snoozeDate = lastWeekStart.isBefore(DateTime.now())
        ? DateTime.now().add(const Duration(hours: 1))
        : lastWeekStart;
    await db.snoozePaymentReminder(sub.id, snoozeDate);
  }
  // _PaymentChoice.postpone: no DB change — dialog shows again on next screen open
}

/// Shows a dialog reminding that the monthly subscription is nearing expiry
/// and asking whether to renew for one more month.
Future<void> showRenewalReminderDialog(
  BuildContext context,
  WidgetRef ref,
  SubscriberWithPlates item,
) async {
  final days = item.daysRemaining.clamp(0, 9999);
  final dateFormat = DateFormat('dd.MM.yyyy');
  final sub = item.subscriber;

  final wantsToRenew = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.autorenew, color: Colors.orange, size: 36),
      title: const Text('Abonman Yakında Bitiyor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: item.plates
                .map((p) => Chip(
                      label: Text(p.plate,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2)),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          if (sub.notes != null && sub.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(sub.notes!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          ],
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(ctx).style,
              children: [
                TextSpan(
                    text: '$days gün',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
                const TextSpan(
                    text: ' içinde abonelik sona eriyor\n'),
                TextSpan(
                    text: '(${dateFormat.format(sub.endDate)})',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Bir ay daha uzatmak ister misiniz?'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hayır, Şimdilik')),
        FilledButton.icon(
          style:
              FilledButton.styleFrom(backgroundColor: Colors.orange),
          icon: const Icon(Icons.autorenew),
          label: const Text('Evet, Uzat'),
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );

  if (wantsToRenew != true || !context.mounted) return;

  final base = sub.endDate.isBefore(DateTime.now())
      ? DateTime.now()
      : sub.endDate;
  final newEndDate = addOneMonth(base);

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
            '(${dateFormat.format(sub.endDate)} tarihinden +1 ay)',
            style:
                TextStyle(fontSize: 12, color: Colors.grey.shade500),
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

  if (confirmed == true && context.mounted) {
    await ref
        .read(databaseProvider)
        .renewSubscriber(sub.id, newEndDate);
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
