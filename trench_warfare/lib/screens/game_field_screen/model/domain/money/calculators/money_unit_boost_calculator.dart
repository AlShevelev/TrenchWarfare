part of money_calculators;

class MoneyUnitBoostCalculator {
  static MoneyUnit calculateCost(UnitBoost boost) => switch(boost) {
    UnitBoost.attack => _MoneyConstants.attackBoosterBuildCost,
    UnitBoost.defence => _MoneyConstants.defenceBoosterBuildCost,
    UnitBoost.commander => _MoneyConstants.commanderBoosterBuildCost,
    UnitBoost.transport => _MoneyConstants.transportBoosterBuildCost,
  };
}