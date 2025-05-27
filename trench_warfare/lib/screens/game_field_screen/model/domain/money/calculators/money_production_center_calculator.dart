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

class MoneyProductionCenterCalculator {
  static MoneyUnit? calculateBuildCost(
          CellTerrain terrain, ProductionCenterType type, ProductionCenterLevel level) =>
      switch (terrain) {
        CellTerrain.plain => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(type, level),
            ProductionCenterType.factory => _calculateBaseCost(type, level),
            ProductionCenterType.airField => _calculateBaseCost(type, level),
            _ => null,
          },
        CellTerrain.wood => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(type, level).multiplyBy(1.2),
            ProductionCenterType.airField => _calculateBaseCost(type, level).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.marsh => null,
        CellTerrain.sand => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(type, level).multiplyBy(1.4),
            ProductionCenterType.airField => _calculateBaseCost(type, level).multiplyBy(1.4),
            _ => null,
          },
        CellTerrain.hills => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(type, level).multiplyBy(1.1),
            ProductionCenterType.factory => _calculateBaseCost(type, level).multiplyBy(1.1),
            _ => null,
          },
        CellTerrain.mountains => null,
        CellTerrain.snow => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(type, level).multiplyBy(1.2),
            ProductionCenterType.factory => _calculateBaseCost(type, level).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.water => switch (type) {
            ProductionCenterType.navalBase => _calculateBaseCost(type, level),
            _ => null,
          },
      };

  static MoneyUnit _calculateBaseCost(ProductionCenterType type, ProductionCenterLevel level) {
    final baseCost = switch (type) {
      ProductionCenterType.city => _MoneyConstants.cityBuildCost,
      ProductionCenterType.factory => _MoneyConstants.factoryBuildCost,
      ProductionCenterType.airField => _MoneyConstants.airFieldBuildCost,
      ProductionCenterType.navalBase => _MoneyConstants.navalBaseBuildCost,
    };

    final levelFactor = switch (level) {
      ProductionCenterLevel.level1 => 1.0,
      ProductionCenterLevel.level2 => 1.0,//2.0,
      ProductionCenterLevel.level3 => 1.0,//3.0,
      ProductionCenterLevel.level4 => 1.0,//4.0,
      ProductionCenterLevel.capital => 1.0,//5.0,
    };

    return baseCost.multiplyBy(levelFactor);
  }
}
