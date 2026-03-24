// Turkish license plate format:
// [City code 01-81] [1-3 letters] [2-4 digits]
// Valid letters: A B C D E F G H I J K L M N O P R S T U V Y Z
// (no Q, W, X and no Turkish special chars on plates)
//
// Examples: 34ABC1234  06A123  35BT42

class PlateValidator {
  PlateValidator._();

  static final _turkishPlateRegex = RegExp(
    r'^(0[1-9]|[1-7][0-9]|8[01])\s?([A-BDFGHJKLMNOPRSTUVYZ]{1,3})\s?(\d{2,4})$',
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
