import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class MoneyUnitBoostCalculator {
  static const baseCurrency = 5;
  static const baseIndustryPoints = 5;

  static MoneyUnit calculateCost(UnitBoost boost) => switch(boost) {
    UnitBoost.attack || UnitBoost.defence => MoneyUnit(currency: baseCurrency, industryPoints: baseIndustryPoints),
    UnitBoost.commander => MoneyUnit(currency: multiplyBy(baseCurrency, 2), industryPoints: 0),
    UnitBoost.transport => MoneyUnit(currency: baseCurrency, industryPoints: multiplyBy(baseIndustryPoints, 2)),
  };
}