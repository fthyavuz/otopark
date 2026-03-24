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
  final bool isSubscriber;

  const CostCalculationResult({
    required this.cost,
    required this.description,
    required this.elapsedMinutes,
    required this.isSubscriber,
  });
}

class CostCalculator {
  CostCalculator._();

  /// Calculates parking cost based on elapsed time and active tariff.
  /// If [isSubscriber] is true, cost is always 0.
  static CostCalculationResult calculate({
    required DateTime entryTime,
    required DateTime exitTime,
    required Tariff tariff,
    bool isSubscriber = false,
  }) {
    final elapsedMinutes = exitTime.difference(entryTime).inMinutes;

    if (isSubscriber) {
      return CostCalculationResult(
        cost: 0,
        description: 'Abonman',
        elapsedMinutes: elapsedMinutes,
        isSubscriber: true,
      );
    }

    final brackets = _parseBrackets(tariff.bracketsJson);

    // Find the matching bracket (sorted ascending by upToMinutes).
    for (final bracket in brackets) {
      if (elapsedMinutes <= bracket.upToMinutes) {
        return CostCalculationResult(
          cost: bracket.price,
          description: _formatDuration(elapsedMinutes),
          elapsedMinutes: elapsedMinutes,
          isSubscriber: false,
        );
      }
    }

    // Exceeds all brackets → full day price.
    return CostCalculationResult(
      cost: tariff.fullDayPrice,
      description: 'Günlük Tarife (${_formatDuration(elapsedMinutes)})',
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
