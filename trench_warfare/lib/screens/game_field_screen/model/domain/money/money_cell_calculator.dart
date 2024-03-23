import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class MoneyCellCalculator {
  static const baseCurrency = 10;
  static const baseIndustryPoints = 10;

  static MoneyUnit getCellIncome(GameFieldCellRead cell) {
    if (cell.terrainModifier != null) {
      // A cell with terrain modifiers doesn't produce money or industry points.
      return MoneyUnit(currency: 0, industryPoints: 0);
    }

    if (cell.productionCenter != null) {
      return switch (cell.productionCenter!.type) {
        ProductionCenterType.city =>
          MoneyUnit(
            currency: baseCurrency * _getLevelIncomeFactor(cell.productionCenter!.level),
            industryPoints: 0,
          ),
        ProductionCenterType.factory =>
          MoneyUnit(
            currency: 0,
            industryPoints: baseIndustryPoints * _getLevelIncomeFactor(cell.productionCenter!.level),
          ),
        ProductionCenterType.navalBase =>
          MoneyUnit(
            currency: baseCurrency * _getLevelIncomeFactor(cell.productionCenter!.level),
            industryPoints: baseIndustryPoints * _getLevelIncomeFactor(cell.productionCenter!.level),
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
          currency: baseCurrency,
          industryPoints: baseIndustryPoints,
        ),
      CellTerrain.wood => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.5),
          industryPoints: multiplyBy(baseIndustryPoints, 0.1),
        ),
      CellTerrain.marsh => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.2),
          industryPoints: multiplyBy(baseIndustryPoints, 0.1),
        ),
      CellTerrain.sand => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.1),
          industryPoints: 0,
        ),
      CellTerrain.hills => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.5),
          industryPoints: multiplyBy(baseIndustryPoints, 0.4),
        ),
      CellTerrain.mountains => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.1),
          industryPoints: multiplyBy(baseIndustryPoints, 0.8),
        ),
      CellTerrain.snow => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.1),
          industryPoints: 0,
        ),
      CellTerrain.water => MoneyUnit(
          currency: multiplyBy(baseCurrency, 0.5),
          industryPoints: multiplyBy(baseIndustryPoints, 0.2),
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
