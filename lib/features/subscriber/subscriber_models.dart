import '../../database/database.dart';

enum SubStatus { active, expiringSoon, expired }

enum SubType { monthly, daily }

class SubscriberWithPlates {
  final Subscriber subscriber;
  final List<SubscriberPlate> plates;

  const SubscriberWithPlates({
    required this.subscriber,
    required this.plates,
  });

  SubType get type =>
      subscriber.subscriberType == 'daily' ? SubType.daily : SubType.monthly;

  SubStatus get status {
    final now = DateTime.now();
    if (!subscriber.isActive) return SubStatus.expired;
    if (subscriber.endDate.isBefore(now)) return SubStatus.expired;
    if (subscriber.endDate.difference(now).inDays <= 7) {
      return SubStatus.expiringSoon;
    }
    return SubStatus.active;
  }

  int get daysRemaining =>
      subscriber.endDate.difference(DateTime.now()).inDays;

  /// True when the monthly fee for the current subscription period has not been paid yet.
  bool get isFeeDue {
    if (type != SubType.monthly) return false;
    if (status == SubStatus.expired) return false;
    final paidUntil = subscriber.feePaidUntil;
    if (paidUntil == null) return true;
    return paidUntil.isBefore(subscriber.endDate);
  }

  /// True when the fee is due AND the payment reminder has not been snoozed.
  bool get shouldShowPaymentReminder {
    if (!isFeeDue) return false;
    final snoozed = subscriber.paymentSnoozedUntil;
    if (snoozed != null && snoozed.isAfter(DateTime.now())) return false;
    return true;
  }

  /// True when a monthly subscriber has 30 or fewer days left (but not expired).
  bool get isNearingExpiry =>
      type == SubType.monthly &&
      status != SubStatus.expired &&
      daysRemaining > 0 &&
      daysRemaining <= 30;

  /// Human-readable status label in Turkish.
  String get statusLabel {
    // Daily subscribers don't expire in the traditional sense.
    if (type == SubType.daily) {
      return subscriber.isActive ? 'Aktif' : 'Pasif';
    }
    switch (status) {
      case SubStatus.active:
        final days = daysRemaining;
        if (days == 0) return 'Bugün sona eriyor';
        return '$days gün kaldı';
      case SubStatus.expiringSoon:
        final days = daysRemaining;
        if (days <= 0) return 'Bugün sona eriyor';
        return '$days gün kaldı';
      case SubStatus.expired:
        final daysAgo = -daysRemaining;
        if (daysAgo == 0) return 'Bugün sona erdi';
        return '$daysAgo gün önce sona erdi';
    }
  }
}

/// Returns a new end date that is exactly 1 month after [from].
DateTime addOneMonth(DateTime from) {
  int newMonth = from.month + 1;
  int newYear = from.year;
  if (newMonth > 12) {
    newMonth -= 12;
    newYear += 1;
  }
  final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  final day = from.day > lastDayOfNewMonth ? lastDayOfNewMonth : from.day;
  return DateTime(newYear, newMonth, day);
}
