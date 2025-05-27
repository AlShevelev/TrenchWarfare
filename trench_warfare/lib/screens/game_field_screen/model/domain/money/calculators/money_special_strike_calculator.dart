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

class MoneySpecialStrikeCalculator {
  static MoneyUnit calculateCost(SpecialStrikeType type) => switch (type) {
        SpecialStrikeType.gasAttack => _MoneyConstants.gasAttackCost,
        SpecialStrikeType.flechettes => _MoneyConstants.flechettesCost,
        SpecialStrikeType.airBombardment => _MoneyConstants.airBombardmentCost,
        SpecialStrikeType.flameTroopers => _MoneyConstants.flameTroopersCost,
        SpecialStrikeType.propaganda => _MoneyConstants.propagandaCost,
      };
}
