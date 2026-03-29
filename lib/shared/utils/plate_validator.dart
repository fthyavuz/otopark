// Turkish license plate format:
// [City code 00-89] [1-3 letters] [2-5 digits]
// Examples: 34 ABC 1234  06 A 123  35 BT 42

class PlateValidator {
  PlateValidator._();

  static final _turkishPlateRegex = RegExp(
    r'^[0-8][0-9]\s[A-Z]{1,3}\s[0-9]{2,5}$',
    caseSensitive: false,
  );

  /// Returns true if [plate] matches the Turkish plate format.
  static bool isTurkishPlate(String plate) {
    final cleaned = plate.replaceAll(RegExp(r'\s+'), ' ').trim();
    return _turkishPlateRegex.hasMatch(cleaned);
  }

  /// Normalises the plate to uppercase with no extra spaces.
  static String normalise(String plate) =>
      plate.toUpperCase().replaceAll(RegExp(r'\s+'), ' ').trim();
}
