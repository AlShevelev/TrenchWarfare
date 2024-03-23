import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/special_strike_type.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class MoneySpecialStrikeCalculator {
  static const baseCurrency = 10;
  static const baseIndustryPoints = 10;

  static MoneyUnit? getCost(SpecialStrikeType type) => switch (type) {
        SpecialStrikeType.gasAttack => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: multiplyBy(baseIndustryPoints, 3),
          ),
        SpecialStrikeType.flechettes => MoneyUnit(
            currency: baseCurrency,
            industryPoints: baseIndustryPoints,
          ),
        SpecialStrikeType.airBombardment => MoneyUnit(
            currency: multiplyBy(baseCurrency, 3),
            industryPoints: multiplyBy(baseIndustryPoints, 3),
          ),
        SpecialStrikeType.flameTroopers => MoneyUnit(
            currency: baseCurrency,
            industryPoints: multiplyBy(baseIndustryPoints, 1.5),
          ),
        SpecialStrikeType.propaganda => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: 0,
          ),
      };
}
