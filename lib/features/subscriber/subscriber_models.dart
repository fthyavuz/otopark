import '../../database/database.dart';

enum SubStatus { active, expiringSoon, expired }

class SubscriberWithPlates {
  final Subscriber subscriber;
  final List<SubscriberPlate> plates;

  const SubscriberWithPlates({
    required this.subscriber,
    required this.plates,
  });

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

  /// Human-readable status label in Turkish.
  String get statusLabel {
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
  // Handle months with fewer days (e.g. Jan 31 + 1 month = Feb 28/29).
  final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  final day = from.day > lastDayOfNewMonth ? lastDayOfNewMonth : from.day;
  return DateTime(newYear, newMonth, day);
}
