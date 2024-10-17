part of money_calculators;

class MoneyUnitsCalculator {
  static MoneyUnit calculateProductionCost(UnitType unitType) => switch (unitType) {
        UnitType.infantry => MoneyUnit(
            currency: _MoneyConstants.unitLandBaseCostCurrency,
            industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
          ).multiplyBy(UnitsPowerWeights.infantry),
        UnitType.machineGuns => MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.machineGuns),
        UnitType.cavalry =>  MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.cavalry),
        UnitType.machineGunnersCart =>  MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.machineGunnersCart),
        UnitType.artillery =>  MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.artillery),
        UnitType.armoredCar =>  MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.armoredCar),
        UnitType.tank =>  MoneyUnit(
          currency: _MoneyConstants.unitLandBaseCostCurrency,
          industryPoints: _MoneyConstants.unitLandBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.tank),
        UnitType.carrier => MoneyUnit(
          currency: _MoneyConstants.unitSeaBaseCostCurrency,
          industryPoints: _MoneyConstants.unitSeaBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.carrier),
        UnitType.destroyer => MoneyUnit(
          currency: _MoneyConstants.unitSeaBaseCostCurrency,
          industryPoints: _MoneyConstants.unitSeaBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.destroyer),
        UnitType.cruiser => MoneyUnit(
          currency: _MoneyConstants.unitSeaBaseCostCurrency,
          industryPoints: _MoneyConstants.unitSeaBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.cruiser),
        UnitType.battleship => MoneyUnit(
          currency: _MoneyConstants.unitSeaBaseCostCurrency,
          industryPoints: _MoneyConstants.unitSeaBaseCostIndustryPoints,
        ).multiplyBy(UnitsPowerWeights.battleship),
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
