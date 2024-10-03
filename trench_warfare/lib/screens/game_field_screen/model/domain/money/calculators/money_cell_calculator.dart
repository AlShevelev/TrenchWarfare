part of money_calculators;

class MoneyCellCalculator {
  static MoneyUnit calculateCellIncome(GameFieldCellRead cell) {
    if (cell.terrainModifier != null) {
      // A cell with terrain modifiers doesn't produce money or industry points.
      return MoneyUnit(currency: 0, industryPoints: 0);
    }

    if (cell.productionCenter != null) {
      final levelFactor = _getLevelIncomeFactor(cell.productionCenter!.level);

      return switch (cell.productionCenter!.type) {
        ProductionCenterType.city => _MoneyConstants.cityIncome.multiplyBy(levelFactor),
        ProductionCenterType.factory => _MoneyConstants.factoryIncome.multiplyBy(levelFactor),
        ProductionCenterType.navalBase => _MoneyConstants.navalBaseIncome.multiplyBy(levelFactor),
        ProductionCenterType.airField => _MoneyConstants.airFieldIncome.multiplyBy(levelFactor),
      };
    }

    return switch (cell.terrain) {
      CellTerrain.plain => _MoneyConstants.cellPlainIncome,
      CellTerrain.wood => _MoneyConstants.cellWoodIncome,
      CellTerrain.marsh => _MoneyConstants.cellMarshIncome,
      CellTerrain.sand => _MoneyConstants.cellSandIncome,
      CellTerrain.hills => _MoneyConstants.cellHillsIncome,
      CellTerrain.mountains => _MoneyConstants.cellMountainsIncome,
      CellTerrain.snow => _MoneyConstants.cellSnowIncome,
      CellTerrain.water => _MoneyConstants.cellWaterIncome,
    };
  }

  static double _getLevelIncomeFactor(ProductionCenterLevel level) => switch (level) {
        ProductionCenterLevel.level1 => 1.0,
        ProductionCenterLevel.level2 => 2.0,
        ProductionCenterLevel.level3 => 3.0,
        ProductionCenterLevel.level4 => 4.0,
        ProductionCenterLevel.capital => 5.0,
      };
}
