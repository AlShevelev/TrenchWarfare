import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';

class MoneyProductionCenterCalculator {
  static const baseCurrency = 20;
  static const baseIndustryPoints = 20;

  static const upgradePerLevelCurrency = 10;
  static const upgradePerLevelIndustryPoints = 10;

  static MoneyUnit? getBuildCost(CellTerrain terrain, ProductionCenterType type, ProductionCenterLevel level) =>
      switch (terrain) {
        CellTerrain.plain => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(level),
            ProductionCenterType.factory => _calculateBaseCost(level),
            ProductionCenterType.airField => _calculateBaseCost(level),
            _ => null,
          },
        CellTerrain.wood => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(level).multiplyBy(1.2),
            ProductionCenterType.airField => _calculateBaseCost(level).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.marsh => null,
        CellTerrain.sand => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(level).multiplyBy(1.4),
            ProductionCenterType.airField => _calculateBaseCost(level).multiplyBy(1.4),
            _ => null,
          },
        CellTerrain.hills => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(level).multiplyBy(1.1),
            ProductionCenterType.factory => _calculateBaseCost(level).multiplyBy(1.1),
            _ => null,
          },
        CellTerrain.mountains => null,
        CellTerrain.snow => switch (type) {
            ProductionCenterType.city => _calculateBaseCost(level).multiplyBy(1.2),
            ProductionCenterType.factory => _calculateBaseCost(level).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.water => switch (type) {
            ProductionCenterType.navalBase => _calculateBaseCost(level),
            _ => null,
          },
      };

  static MoneyUnit _calculateBaseCost(ProductionCenterLevel level) {
    if (level == ProductionCenterLevel.level1) {
      return MoneyUnit(currency: baseCurrency, industryPoints: baseIndustryPoints);
    }

    final levelFactor = switch (level) {
      ProductionCenterLevel.level1 => throw UnsupportedError("This level is not supported here"),
      ProductionCenterLevel.level2 => 2.0,
      ProductionCenterLevel.level3 => 3.0,
      ProductionCenterLevel.level4 => 4.0,
      ProductionCenterLevel.capital => 5.0,
    };

    return MoneyUnit(
      currency: upgradePerLevelCurrency,
      industryPoints: upgradePerLevelIndustryPoints,
    ).multiplyBy(levelFactor);
  }
}
