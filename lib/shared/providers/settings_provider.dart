import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLotName = 'lot_name';

// Loaded once in main() and injected via override.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences not injected'),
);

/// The parking lot name chosen by the user.
/// Empty string means not set yet (first launch).
final lotNameProvider =
    StateNotifierProvider<LotNameNotifier, String>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return LotNameNotifier(prefs);
});

class LotNameNotifier extends StateNotifier<String> {
  LotNameNotifier(this._prefs)
      : super(_prefs.getString(_kLotName) ?? '');

  final SharedPreferences _prefs;

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    await _prefs.setString(_kLotName, trimmed);
    state = trimmed;
  }
}
