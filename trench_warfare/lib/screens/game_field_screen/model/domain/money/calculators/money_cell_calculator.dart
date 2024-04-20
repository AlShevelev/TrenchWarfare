part of money_calculators;

class MoneyCellCalculator {
  static const _baseCurrency = 10;
  static const _baseIndustryPoints = 10;

  static MoneyUnit calculateCellIncome(GameFieldCellRead cell) {
    if (cell.terrainModifier != null) {
      // A cell with terrain modifiers doesn't produce money or industry points.
      return MoneyUnit(currency: 0, industryPoints: 0);
    }

    if (cell.productionCenter != null) {
      return switch (cell.productionCenter!.type) {
        ProductionCenterType.city =>
          MoneyUnit(
            currency: _baseCurrency * _getLevelIncomeFactor(cell.productionCenter!.level),
            industryPoints: 0,
          ),
        ProductionCenterType.factory =>
          MoneyUnit(
            currency: 0,
            industryPoints: _baseIndustryPoints * _getLevelIncomeFactor(cell.productionCenter!.level),
          ),
        ProductionCenterType.navalBase =>
          MoneyUnit(
            currency: _baseCurrency * _getLevelIncomeFactor(cell.productionCenter!.level),
            industryPoints: _baseIndustryPoints * _getLevelIncomeFactor(cell.productionCenter!.level),
          ),
        ProductionCenterType.airField =>
          MoneyUnit(
            currency: 0,
            industryPoints: 0,
          ),
      };
    }

    return switch (cell.terrain) {
      CellTerrain.plain => MoneyUnit(
          currency: _baseCurrency,
          industryPoints: _baseIndustryPoints,
        ),
      CellTerrain.wood => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.5),
          industryPoints: multiplyBy(_baseIndustryPoints, 0.1),
        ),
      CellTerrain.marsh => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.2),
          industryPoints: multiplyBy(_baseIndustryPoints, 0.1),
        ),
      CellTerrain.sand => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.1),
          industryPoints: 0,
        ),
      CellTerrain.hills => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.5),
          industryPoints: multiplyBy(_baseIndustryPoints, 0.4),
        ),
      CellTerrain.mountains => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.1),
          industryPoints: multiplyBy(_baseIndustryPoints, 0.8),
        ),
      CellTerrain.snow => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.1),
          industryPoints: 0,
        ),
      CellTerrain.water => MoneyUnit(
          currency: multiplyBy(_baseCurrency, 0.5),
          industryPoints: multiplyBy(_baseIndustryPoints, 0.2),
        ),
    };
  }

  static int _getLevelIncomeFactor(ProductionCenterLevel level) => switch (level) {
        ProductionCenterLevel.level1 => 1,
        ProductionCenterLevel.level2 => 2,
        ProductionCenterLevel.level3 => 3,
        ProductionCenterLevel.level4 => 4,
        ProductionCenterLevel.capital => 5,
      };
}
