import '../../database/database.dart';
import '../../shared/utils/cost_calculator.dart';

/// Carries all data needed to display the payment screen and confirm exit.
class PaymentData {
  final ParkingRecord record;
  final Tariff tariff;
  final CostCalculationResult costResult;
  final DateTime exitTime;

  const PaymentData({
    required this.record,
    required this.tariff,
    required this.costResult,
    required this.exitTime,
  });
}
