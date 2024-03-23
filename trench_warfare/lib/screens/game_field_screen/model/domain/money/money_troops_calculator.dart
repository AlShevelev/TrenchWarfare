import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class MoneyTroopsCalculator {
  static const baseCurrency = 5;
  static const baseIndustryPoints = 5;

  static MoneyUnit getProductionCost(UnitType unitType) => switch (unitType) {
        UnitType.infantry => MoneyUnit(
            currency: baseCurrency,
            industryPoints: 0,
          ),
        UnitType.machineGuns => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: baseIndustryPoints,
          ),
        UnitType.cavalry => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: 0,
          ),
        UnitType.machineGunnersCart => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: multiplyBy(baseIndustryPoints, 2),
          ),
        UnitType.artillery => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: multiplyBy(baseIndustryPoints, 3),
          ),
        UnitType.armoredCar => MoneyUnit(
            currency: multiplyBy(baseCurrency, 2),
            industryPoints: multiplyBy(baseIndustryPoints, 3),
          ),
        UnitType.tank => MoneyUnit(
            currency: multiplyBy(baseCurrency, 3),
            industryPoints: multiplyBy(baseIndustryPoints, 4),
          ),
        UnitType.carrier => throw UnsupportedError("Carrier is a card, not a unit"),
        UnitType.destroyer => MoneyUnit(
            currency: multiplyBy(baseCurrency, 4),
            industryPoints: multiplyBy(baseIndustryPoints, 6),
          ),
        UnitType.cruiser => MoneyUnit(
            currency: multiplyBy(baseCurrency, 5),
            industryPoints: multiplyBy(baseIndustryPoints, 8),
          ),
        UnitType.battleship => MoneyUnit(
            currency: multiplyBy(baseCurrency, 6),
            industryPoints: multiplyBy(baseIndustryPoints, 12),
          ),
      };
}
