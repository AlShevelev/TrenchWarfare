/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of money_calculators;

class MoneyUnitBoostCalculator {
  static MoneyUnit calculateCost(UnitBoost boost) => switch(boost) {
    UnitBoost.attack => _MoneyConstants.attackBoosterBuildCost,
    UnitBoost.defence => _MoneyConstants.defenceBoosterBuildCost,
    UnitBoost.commander => _MoneyConstants.commanderBoosterBuildCost,
    UnitBoost.transport => _MoneyConstants.transportBoosterBuildCost,
  };
}