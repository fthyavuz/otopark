import 'package:flutter/services.dart';

/// Auto-formats Turkish plate input as the user types.
///
/// Turkish plate format: [01-81] [1-3 letters] [2-4 digits]
/// Example: "34ABC1234" → "34 ABC 1234"
///
/// Spaces are inserted automatically:
///   - After the 2-digit city code (when letters start)
///   - After the letters (when digits start)
class PlateInputFormatter extends TextInputFormatter {
  const PlateInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final formatted = format(raw);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Formats a raw (no-space) plate string into display form.
  static String format(String raw) {
    if (raw.isEmpty) return '';

    // Part 1: up to 2 leading digits (city code)
    int i = 0;
    while (i < raw.length && i < 2 && _isDigit(raw[i])) {
      i++;
    }
    final city = raw.substring(0, i);
    if (city.isEmpty) return raw;

    // Part 2: letters immediately after city code
    final letterStart = i;
    while (i < raw.length && _isLetter(raw[i])) {
      i++;
    }
    final letters = raw.substring(letterStart, i);

    // Part 3: remaining digits
    final numbers = raw.substring(i);

    if (letters.isEmpty) return city;
    if (numbers.isEmpty) return '$city $letters';
    return '$city $letters $numbers';
  }

  static bool _isDigit(String c) {
    final code = c.codeUnitAt(0);
    return code >= 48 && code <= 57; // 0-9
  }

  static bool _isLetter(String c) {
    final code = c.codeUnitAt(0);
    return code >= 65 && code <= 90; // A-Z
  }
}
