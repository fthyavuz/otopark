import 'dart:convert';

import '../../database/database.dart';

class TariffBracket {
  final int upToMinutes;
  final double price;

  const TariffBracket({required this.upToMinutes, required this.price});

  factory TariffBracket.fromJson(Map<String, dynamic> json) => TariffBracket(
        upToMinutes: json['upToMinutes'] as int,
        price: (json['price'] as num).toDouble(),
      );
}

class CostCalculationResult {
  final double cost;
  final String description;
  final int elapsedMinutes;

  /// True for monthly subscribers (exit is free).
  final bool isSubscriber;

  /// True for daily subscribers (pay once per day).
  final bool isDailySubscriber;

  /// True if vehicle was large (50 % surcharge applied).
  final bool isLargeVehicle;

  const CostCalculationResult({
    required this.cost,
    required this.description,
    required this.elapsedMinutes,
    required this.isSubscriber,
    this.isDailySubscriber = false,
    this.isLargeVehicle = false,
  });
}

class CostCalculator {
  CostCalculator._();

  /// Calculates parking cost.
  ///
  /// Priority order:
  ///   1. Monthly subscriber → free
  ///   2. Daily subscriber   → dailyFee once per day, then free
  ///   3. Large vehicle      → normal cost × 1.5
  ///   4. Normal             → bracket-based tariff
  static CostCalculationResult calculate({
    required DateTime entryTime,
    required DateTime exitTime,
    required Tariff tariff,
    bool isMonthlySubscriber = false,
    bool isDailySubscriber = false,
    double dailyFee = 150.0,
    bool alreadyPaidDailyFeeToday = false,
    bool isLargeVehicle = false,
  }) {
    final elapsedMinutes = exitTime.difference(entryTime).inMinutes;

    // 1. Monthly subscriber — always free
    if (isMonthlySubscriber) {
      return CostCalculationResult(
        cost: 0,
        description: 'Aylık Abonman',
        elapsedMinutes: elapsedMinutes,
        isSubscriber: true,
      );
    }

    // 2. Daily subscriber
    if (isDailySubscriber) {
      if (alreadyPaidDailyFeeToday) {
        return CostCalculationResult(
          cost: 0,
          description: 'Günlük Abone (bugün ödendi)',
          elapsedMinutes: elapsedMinutes,
          isSubscriber: false,
          isDailySubscriber: true,
          isLargeVehicle: isLargeVehicle,
        );
      }
      final fee = isLargeVehicle ? dailyFee * 1.5 : dailyFee;
      final desc = isLargeVehicle
          ? 'Günlük Abonman – Büyük Araç (+%50)'
          : 'Günlük Abonman';
      return CostCalculationResult(
        cost: fee,
        description: desc,
        elapsedMinutes: elapsedMinutes,
        isSubscriber: false,
        isDailySubscriber: true,
        isLargeVehicle: isLargeVehicle,
      );
    }

    // 3 & 4. Normal bracket calculation (large vehicle multiplier applied after)
    final brackets = _parseBrackets(tariff.bracketsJson);
    double baseCost = tariff.fullDayPrice;
    String baseDescription =
        'Günlük Tarife (${_formatDuration(elapsedMinutes)})';

    for (final bracket in brackets) {
      if (elapsedMinutes <= bracket.upToMinutes) {
        baseCost = bracket.price;
        baseDescription = _formatDuration(elapsedMinutes);
        break;
      }
    }

    if (isLargeVehicle) {
      return CostCalculationResult(
        cost: baseCost * 1.5,
        description: 'Büyük Araç – $baseDescription (+%50)',
        elapsedMinutes: elapsedMinutes,
        isSubscriber: false,
        isLargeVehicle: true,
      );
    }

    return CostCalculationResult(
      cost: baseCost,
      description: baseDescription,
      elapsedMinutes: elapsedMinutes,
      isSubscriber: false,
    );
  }

  static List<TariffBracket> _parseBrackets(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => TariffBracket.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.upToMinutes.compareTo(b.upToMinutes));
  }

  static String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes dakika';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h saat' : '$h saat $m dakika';
  }
}
