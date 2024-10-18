part of money_calculators;

class MoneyUnitsCalculator {
  static MoneyUnit calculateProductionCost(UnitType unitType) => switch (unitType) {
        UnitType.infantry => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.infantry),
        UnitType.machineGuns => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.machineGuns),
        UnitType.cavalry => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.cavalry),
        UnitType.machineGunnersCart =>
          _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.machineGunnersCart),
        UnitType.artillery => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.artillery),
        UnitType.armoredCar => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.armoredCar),
        UnitType.tank => _MoneyConstants.unitLandBaseCost.multiplyBy(UnitsPowerWeights.tank),

        UnitType.carrier => _MoneyConstants.unitSeaBaseCost.multiplyBy(UnitsPowerWeights.carrier),
        UnitType.destroyer => _MoneyConstants.unitSeaBaseCost.multiplyBy(UnitsPowerWeights.destroyer),
        UnitType.cruiser => _MoneyConstants.unitSeaBaseCost.multiplyBy(UnitsPowerWeights.cruiser),
        UnitType.battleship => _MoneyConstants.unitSeaBaseCost.multiplyBy(UnitsPowerWeights.battleship),
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
