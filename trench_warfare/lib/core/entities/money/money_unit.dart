/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/shared/utils/math.dart';

class MoneyUnit {
  final int currency;

  final int industryPoints;

  @override
  int get hashCode => InGameMath.pair(currency, industryPoints);

  static MoneyUnit get zero => MoneyUnit(currency: 0, industryPoints: 0);

  MoneyUnit({required this.currency, required this.industryPoints});

  @override
  bool operator ==(covariant MoneyUnit other) =>
      other.currency == currency && other.industryPoints == industryPoints;

  MoneyUnit operator +(covariant MoneyUnit other) =>
      MoneyUnit(currency: currency + other.currency, industryPoints: industryPoints + other.industryPoints);

  MoneyUnit operator -(covariant MoneyUnit other) =>
      MoneyUnit(currency: currency - other.currency, industryPoints: industryPoints - other.industryPoints);

  bool operator >=(covariant MoneyUnit other) =>
      currency >= other.currency && industryPoints >= other.industryPoints;

  MoneyUnit multiplyBy(double factor) => MoneyUnit(
        currency: InGameMath.multiplyBy(currency, factor),
        industryPoints: InGameMath.multiplyBy(industryPoints, factor),
      );

  MoneyUnit copy({int? currency, int? industryPoints}) => MoneyUnit(
        currency: currency ?? this.currency,
        industryPoints: industryPoints ?? this.industryPoints,
      );

  @override
  String toString() => 'MONEY_UNIT: {currency: $currency; industryPoints: $industryPoints}';
}
