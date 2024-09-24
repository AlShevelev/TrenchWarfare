part of money_calculators;

class MoneyUnitsCalculator {
  static const _baseCurrency = 5;
  static const _baseIndustryPoints = 5;

  static const _expenseFactor = 4.0;

  static MoneyUnit calculateProductionCost(UnitType unitType) => switch (unitType) {
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

  static MoneyUnit calculateExpense(Unit unit) {
    final productionCost = calculateProductionCost(unit.type);
    var expense = MoneyUnit(
      currency: _calculateExpenseComponent(productionCost.currency, unit),
      industryPoints: _calculateExpenseComponent(productionCost.industryPoints, unit),
    );

    if (unit is Carrier) {
      for (final carrierUnit in unit.units) {
        expense += calculateExpense(carrierUnit);
      }
    }

    return expense;
  }

  static int _calculateExpenseComponent(int productionComponent, Unit unit) {
    final healthPart = unit.health / unit.maxHealth;
    final experiencePart = 0.5 + 0.1 * UnitExperienceRank.asNumber(unit.experienceRank);

    return ((productionComponent.toDouble() * (healthPart + experiencePart)) / (2.0 * _expenseFactor))
        .toInt();
  }
}
