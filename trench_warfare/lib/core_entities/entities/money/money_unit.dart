import 'package:trench_warfare/shared/utils/math.dart' as math;

class MoneyUnit {
  final int currency;

  final int industryPoints;

  @override
  int get hashCode => math.pair(currency, industryPoints);

  static MoneyUnit get zero => MoneyUnit(currency: 0, industryPoints: 0);

  MoneyUnit({required this.currency, required this.industryPoints});

  @override
  bool operator ==(covariant MoneyUnit other) => other.currency == currency && other.industryPoints == industryPoints;

  MoneyUnit operator +(covariant MoneyUnit other) =>
      MoneyUnit(currency: currency + other.currency, industryPoints: industryPoints + other.industryPoints);

  MoneyUnit operator -(covariant MoneyUnit other) =>
      MoneyUnit(currency: currency - other.currency, industryPoints: industryPoints - other.industryPoints);

  MoneyUnit multiplyBy(double factor) => MoneyUnit(
        currency: math.multiplyBy(currency, factor),
        industryPoints: math.multiplyBy(industryPoints, factor),
      );
}
