part of money_calculators;

class MoneyTroopsCalculator {
  static const _baseCurrency = 5;
  static const _baseIndustryPoints = 5;

  static MoneyUnit getProductionCost(UnitType unitType) => switch (unitType) {
        UnitType.infantry => MoneyUnit(
            currency: _baseCurrency,
            industryPoints: 0,
          ),
        UnitType.machineGuns => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: _baseIndustryPoints,
          ),
        UnitType.cavalry => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: 0,
          ),
        UnitType.machineGunnersCart => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 2),
          ),
        UnitType.artillery => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 3),
          ),
        UnitType.armoredCar => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 3),
          ),
        UnitType.tank => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 3),
            industryPoints: multiplyBy(_baseIndustryPoints, 4),
          ),
        UnitType.carrier => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 4),
          industryPoints: multiplyBy(_baseIndustryPoints, 6),
        ),
        UnitType.destroyer => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 4),
            industryPoints: multiplyBy(_baseIndustryPoints, 6),
          ),
        UnitType.cruiser => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 5),
            industryPoints: multiplyBy(_baseIndustryPoints, 8),
          ),
        UnitType.battleship => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 6),
            industryPoints: multiplyBy(_baseIndustryPoints, 12),
          ),
      };
}
