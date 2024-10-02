part of money_calculators;

class MoneyUnitsCalculator {
  static MoneyUnit calculateProductionCost(UnitType unitType) => switch (unitType) {
        UnitType.infantry => MoneyUnit(
            currency: _MoneyConstants.unitBaseCostCurrency,
            industryPoints: _MoneyConstants.unitBaseCostIndustryPoints,
          ),
        UnitType.machineGuns => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 2),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 5),
          ),
        UnitType.cavalry => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 2),
            industryPoints: _MoneyConstants.unitBaseCostIndustryPoints,
          ),
        UnitType.machineGunnersCart => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 3),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 10),
          ),
        UnitType.artillery => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 4),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 15),
          ),
        UnitType.armoredCar => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 4),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 15),
          ),
        UnitType.tank => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 8),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 30),
          ),
        UnitType.carrier => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 5),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 30),
          ),
        UnitType.destroyer => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 5),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 20),
          ),
        UnitType.cruiser => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 9),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 40),
          ),
        UnitType.battleship => MoneyUnit(
            currency: multiplyBy(_MoneyConstants.unitBaseCostCurrency, 14),
            industryPoints: multiplyBy(_MoneyConstants.unitBaseCostIndustryPoints, 60),
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

    return ((productionComponent.toDouble() * (healthPart + experiencePart)) /
            (2.0 * _MoneyConstants.unitExpenseFactor))
        .round();
  }
}
