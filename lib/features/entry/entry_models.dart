import '../../database/database.dart';

/// Data passed to the subscription payment screen.
class SubscriptionPaymentData {
  final String plate;
  final String vehicleType; // 'normal' | 'large'
  final double amount;
  final bool isRenewal; // true = extending existing subscription
  final String notes;

  const SubscriptionPaymentData({
    required this.plate,
    required this.vehicleType,
    required this.amount,
    this.isRenewal = false,
    this.notes = '',
  });
}

/// Summarises what we know about a vehicle at entry-lookup time.
class VehicleLookupResult {
  final RegisteredVehicle? registered; // null = new vehicle
  final bool isInsideAlready;

  const VehicleLookupResult({
    this.registered,
    this.isInsideAlready = false,
  });

  bool get isNewVehicle => registered == null;
  bool get isLargeVehicle => registered?.vehicleType == 'large';
  bool get isMonthlySubscriber =>
      registered?.subscriptionType == 'monthly' &&
      registered?.subscriptionEndDate != null &&
      registered!.subscriptionEndDate!.isAfter(DateTime.now());
  bool get isMonthlyExpired =>
      registered?.subscriptionType == 'monthly' &&
      (registered?.subscriptionEndDate == null ||
          !registered!.subscriptionEndDate!.isAfter(DateTime.now()));
  bool get isDailySubscriber => registered?.subscriptionType == 'daily';
}
