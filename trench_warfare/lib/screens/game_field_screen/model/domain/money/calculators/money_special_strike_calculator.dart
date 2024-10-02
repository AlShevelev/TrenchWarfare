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
