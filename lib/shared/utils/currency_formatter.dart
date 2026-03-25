import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _numFmt = NumberFormat('#,##0', 'tr_TR');

  /// Formats [amount] as Turkish Lira: "₺ 1.500"
  static String format(double amount) {
    return '₺ ${_numFmt.format(amount.round())}';
  }
}
