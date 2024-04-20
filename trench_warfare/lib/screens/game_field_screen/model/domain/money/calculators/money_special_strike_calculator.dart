part of money_calculators;

class MoneySpecialStrikeCalculator {
  static const _baseCurrency = 10;
  static const _baseIndustryPoints = 10;

  static MoneyUnit calculateCost(SpecialStrikeType type) => switch (type) {
        SpecialStrikeType.gasAttack => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 3),
          ),
        SpecialStrikeType.flechettes => MoneyUnit(
            currency: _baseCurrency,
            industryPoints: _baseIndustryPoints,
          ),
        SpecialStrikeType.airBombardment => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 3),
            industryPoints: multiplyBy(_baseIndustryPoints, 3),
          ),
        SpecialStrikeType.flameTroopers => MoneyUnit(
            currency: _baseCurrency,
            industryPoints: multiplyBy(_baseIndustryPoints, 1.5),
          ),
        SpecialStrikeType.propaganda => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: 0,
          ),
      };
}
