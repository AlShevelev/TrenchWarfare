import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class MoneyUnitBoostCalculator {
  static const _baseCurrency = 5;
  static const _baseIndustryPoints = 5;

  static MoneyUnit calculateCost(UnitBoost boost) => switch(boost) {
    UnitBoost.attack || UnitBoost.defence => MoneyUnit(currency: _baseCurrency, industryPoints: _baseIndustryPoints),
    UnitBoost.commander => MoneyUnit(currency: multiplyBy(_baseCurrency, 2), industryPoints: 0),
    UnitBoost.transport => MoneyUnit(currency: _baseCurrency, industryPoints: multiplyBy(_baseIndustryPoints, 2)),
  };
}