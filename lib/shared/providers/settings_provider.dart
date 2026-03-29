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

// ─── Cleaning settings keys ───────────────────────────────────────────────────

const _kCleaningCompanyName = 'cleaning_company_name';
const _kCleaningPricesEditable = 'cleaning_prices_editable';
const _kCleaningPriceInterior = 'cleaning_price_interior';
const _kCleaningPriceExterior = 'cleaning_price_exterior';
const _kCleaningPriceInteriorExterior = 'cleaning_price_interior_exterior';
const _kCleaningPriceFull = 'cleaning_price_full';
const _kCleaningDiscountParked = 'cleaning_discount_parked';
const _kCleaningDiscountDaily = 'cleaning_discount_daily';
const _kCleaningDiscountMonthly = 'cleaning_discount_monthly';
const _kCleaningParkingShareRatio = 'cleaning_parking_share_ratio';

class CleaningSettings {
  final String companyName;
  final bool pricesEditable;
  final double priceInterior;
  final double priceExterior;
  final double priceInteriorExterior;
  final double priceFull;
  final double discountParked;
  final double discountDaily;
  final double discountMonthly;
  final double parkingShareRatio;

  const CleaningSettings({
    this.companyName = 'Oto Temizlik',
    this.pricesEditable = false,
    this.priceInterior = 100.0,
    this.priceExterior = 150.0,
    this.priceInteriorExterior = 200.0,
    this.priceFull = 300.0,
    this.discountParked = 0.0,
    this.discountDaily = 0.0,
    this.discountMonthly = 0.0,
    this.parkingShareRatio = 1.0 / 3.0,
  });

  double priceForType(String serviceType) => switch (serviceType) {
        'interior' => priceInterior,
        'exterior' => priceExterior,
        'interior_exterior' => priceInteriorExterior,
        'full' => priceFull,
        _ => priceInterior,
      };
}

final cleaningSettingsProvider =
    StateNotifierProvider<CleaningSettingsNotifier, CleaningSettings>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return CleaningSettingsNotifier(prefs);
});

class CleaningSettingsNotifier extends StateNotifier<CleaningSettings> {
  CleaningSettingsNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static CleaningSettings _load(SharedPreferences p) => CleaningSettings(
        companyName: p.getString(_kCleaningCompanyName) ?? 'Oto Temizlik',
        pricesEditable: p.getBool(_kCleaningPricesEditable) ?? false,
        priceInterior: p.getDouble(_kCleaningPriceInterior) ?? 100.0,
        priceExterior: p.getDouble(_kCleaningPriceExterior) ?? 150.0,
        priceInteriorExterior:
            p.getDouble(_kCleaningPriceInteriorExterior) ?? 200.0,
        priceFull: p.getDouble(_kCleaningPriceFull) ?? 300.0,
        discountParked: p.getDouble(_kCleaningDiscountParked) ?? 0.0,
        discountDaily: p.getDouble(_kCleaningDiscountDaily) ?? 0.0,
        discountMonthly: p.getDouble(_kCleaningDiscountMonthly) ?? 0.0,
        parkingShareRatio:
            p.getDouble(_kCleaningParkingShareRatio) ?? (1.0 / 3.0),
      );

  Future<void> update({
    String? companyName,
    bool? pricesEditable,
    double? priceInterior,
    double? priceExterior,
    double? priceInteriorExterior,
    double? priceFull,
    double? discountParked,
    double? discountDaily,
    double? discountMonthly,
    double? parkingShareRatio,
  }) async {
    if (companyName != null) {
      await _prefs.setString(_kCleaningCompanyName, companyName);
    }
    if (pricesEditable != null) {
      await _prefs.setBool(_kCleaningPricesEditable, pricesEditable);
    }
    if (priceInterior != null) {
      await _prefs.setDouble(_kCleaningPriceInterior, priceInterior);
    }
    if (priceExterior != null) {
      await _prefs.setDouble(_kCleaningPriceExterior, priceExterior);
    }
    if (priceInteriorExterior != null) {
      await _prefs.setDouble(
          _kCleaningPriceInteriorExterior, priceInteriorExterior);
    }
    if (priceFull != null) {
      await _prefs.setDouble(_kCleaningPriceFull, priceFull);
    }
    if (discountParked != null) {
      await _prefs.setDouble(_kCleaningDiscountParked, discountParked);
    }
    if (discountDaily != null) {
      await _prefs.setDouble(_kCleaningDiscountDaily, discountDaily);
    }
    if (discountMonthly != null) {
      await _prefs.setDouble(_kCleaningDiscountMonthly, discountMonthly);
    }
    if (parkingShareRatio != null) {
      await _prefs.setDouble(_kCleaningParkingShareRatio, parkingShareRatio);
    }
    state = _load(_prefs);
  }
}
