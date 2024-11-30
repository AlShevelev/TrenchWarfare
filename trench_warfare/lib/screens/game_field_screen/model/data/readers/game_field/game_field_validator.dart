import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';

class GameFieldValidator {
  static void validate(GameField gameField) {
    for (var cell in gameField.cells) {
      // Units
      _validateLandUnitsOnLandCell(cell);
      _validateSeaUnitsOnWaterCell(cell);
      _validateNoMinesForUnits(cell);
      _validateSeaUnitCanNotHaveTransportBooster(cell);

      // Production centers
      _validateLandProductionCenterMustBeOnLandCell(cell);
      _validateSeaProductionCenterMustBeOnSea(cell);
      _validateCellWithProductionCenterMustNotContainTerrainModifier(cell);
      _validateProductionCenterMaxLevel(cell);

      // Terrain modifies
      _validateLandTerrainModifierMustBeOnLandCell(cell);
      _validateSeaTerrainModifierMustBeOnSeaCell(cell);

      // Carrier
      _validateCarrierCanContainLandUnitsOnly(cell);

      // Specific rules
      _validateWoodsProductionCenters(cell);
      _validateWoodsTerrainModifiers(cell);
      _validateMarshProductionCenters(cell);
      _validateMarshTerrainModifiers(cell);
      _validateMarshUnits(cell);
      _validateSandProductionCenters(cell);
      _validateSandTerrainModifiers(cell);
      _validateHillsProductionCenters(cell);
      _validateHillsTerrainModifiers(cell);
      _validateMountainsProductionCenters(cell);
      _validateMountainsTerrainModifiers(cell);
      _validateMountainsUnits(cell);
      _validateSnowMountainsProductionCenters(cell);
      _validateSnowTerrainModifiers(cell);
    }
  }

  /// Land units must be on a land cell only
  static void _validateLandUnitsOnLandCell(GameFieldCell cell) {
    if (!cell.isLand) {
      if (cell.units.any((e) => e.isLand)) {
        throw AssertionError("Land units must be on a land cell only [${cell.row}; ${cell.col}]");
      }
    }
  }

  /// Sea units must be on a sea cell only
  static void _validateSeaUnitsOnWaterCell(GameFieldCell cell) {
    if (cell.isLand && !cell.hasRiver) {
      if (cell.units.any((e) => !e.isLand)) {
        throw AssertionError("Sea units must be on a sea cell only [${cell.row}; ${cell.col}]");
      }
    }
  }

  /// A sea unit can't have a transport booster
  static void _validateSeaUnitCanNotHaveTransportBooster(GameFieldCell cell) {
    if (cell.units.isNotEmpty) {
      if (cell.units.any((u) =>
          !u.isLand && (u.boost1 == UnitBoost.transport || u.boost2 == UnitBoost.transport || u.boost3 == UnitBoost.transport))) {
        throw AssertionError("A sea unit can't have a transport booster (cell is: [${cell.row}; ${cell.col}])");
      }
    }
  }

  /// A cell with a mine field can't contain units
  static void _validateNoMinesForUnits(GameFieldCell cell) {
    if (cell.units.isNotEmpty) {
      if (cell.terrainModifier != null &&
          (cell.terrainModifier!.type == TerrainModifierType.seaMine ||
              cell.terrainModifier!.type == TerrainModifierType.landMine)) {
        throw AssertionError("A cell [${cell.row}; ${cell.col}] with a mine field can't contain units");
      }
    }
  }

  // A land production center must be on a land cell
  static void _validateLandProductionCenterMustBeOnLandCell(GameFieldCell cell) {
    if (cell.productionCenter != null && cell.productionCenter!.isLand) {
      if (!cell.isLand) {
        throw AssertionError("A land production center must be on a land cell [${cell.row}; ${cell.col}]");
      }
    }
  }

  // A sea production center must be on a sea cell
  static void _validateSeaProductionCenterMustBeOnSea(GameFieldCell cell) {
    if (cell.productionCenter != null && !cell.productionCenter!.isLand) {
      if (cell.isLand) {
        throw AssertionError("A sea production center must be on a sea cell [${cell.row}; ${cell.col}]");
      }
    }
  }

  // A cell with a production center mustn't contain a terrain modifier
  static void _validateCellWithProductionCenterMustNotContainTerrainModifier(GameFieldCell cell) {
    if (cell.productionCenter != null && cell.terrainModifier != null) {
      throw AssertionError("A cell [${cell.row}; ${cell.col}] with a production center mustn't contain a terrain modifier");
    }
  }

  // A level of a production center if too high
  static void _validateProductionCenterMaxLevel(GameFieldCell cell) {
    final productionCenter = cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    if (productionCenter.type == ProductionCenterType.airField) {
      if (productionCenter.level == ProductionCenterLevel.level3 ||
          productionCenter.level == ProductionCenterLevel.level4 ||
          productionCenter.level == ProductionCenterLevel.capital) {
        throw AssertionError("A level of a production center if too high (the cell is: [${cell.row}; ${cell.col}])");
      }
    }

    if (productionCenter.type == ProductionCenterType.navalBase) {
      if (productionCenter.level == ProductionCenterLevel.level4 || productionCenter.level == ProductionCenterLevel.capital) {
        throw AssertionError("A level of a production center if too high (the cell is: [${cell.row}; ${cell.col}])");
      }
    }

    if (productionCenter.type == ProductionCenterType.factory) {
      if (productionCenter.level == ProductionCenterLevel.capital) {
        throw AssertionError("A level of a production center if too high (the cell is: [${cell.row}; ${cell.col}])");
      }
    }
  }

  // A land terrain modifier must be on a land cell
  static void _validateLandTerrainModifierMustBeOnLandCell(GameFieldCell cell) {
    if (cell.terrainModifier != null && cell.terrainModifier!.isLand) {
      if (!cell.isLand) {
        throw AssertionError("A land terrain modifier must be on a land cell [${cell.row}; ${cell.col}]");
      }
    }
  }

  // A sea terrain modifier must be on a sea cell
  static void _validateSeaTerrainModifierMustBeOnSeaCell(GameFieldCell cell) {
    if (cell.terrainModifier != null && !cell.terrainModifier!.isLand) {
      if (cell.isLand && !cell.hasRiver) {
        throw AssertionError("A sea terrain modifier must be on a sea cell [${cell.row}; ${cell.col}]");
      }
    }
  }

  /// A carrier can contain land units only
  static void _validateCarrierCanContainLandUnitsOnly(GameFieldCell cell) {
    for (var unit in cell.units) {
      if (unit is Carrier && unit.units.any((cu) => !cu.isLand)) {
        throw AssertionError("A carrier can contain land units only (the cell is [${cell.row}; ${cell.col}])");
      }
    }
  }

  // Woods can't contain a factory
  static void _validateWoodsProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.wood) {
      if (cell.productionCenter != null && cell.productionCenter!.type == ProductionCenterType.factory) {
        throw AssertionError("Woods cell [${cell.row}; ${cell.col}] can't contain a factory");
      }
    }
  }

  // Woods can contain a trench only
  static void _validateWoodsTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.wood) {
      if (cell.terrainModifier != null && cell.terrainModifier!.type != TerrainModifierType.trench) {
        throw AssertionError("Woods cell [${cell.row}; ${cell.col}] can contain a trench only");
      }
    }
  }

  // Marsh can't contain a factory, a city or an air field
  static void _validateMarshProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.marsh) {
      if (cell.productionCenter != null) {
        throw AssertionError("Marsh cell [${cell.row}; ${cell.col}] can't contain a factory, a city or an air field");
      }
    }
  }

  // Marsh can't contain an anti-air gun or a minefield
  static void _validateMarshTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.marsh) {
      if (cell.terrainModifier != null &&
          (cell.terrainModifier!.type == TerrainModifierType.antiAirGun ||
              cell.terrainModifier!.type == TerrainModifierType.landMine)) {
        throw AssertionError("Marsh cell [${cell.row}; ${cell.col}] can't contain an anti-air gun or a minefield");
      }
    }
  }

  // Marsh can contain infantry, machine gunners and cavalry only
  static void _validateMarshUnits(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.marsh) {
      if (cell.units.isNotEmpty &&
          !cell.units.any(
              (u) => u.type == UnitType.infantry || u.type == UnitType.machineGuns || u.type == UnitType.cavalry)) {
        throw AssertionError("Marsh cell [${cell.row}; ${cell.col}] can contain infantry, machine gunners and cavalry only");
      }
    }
  }

  // Sand can't contain a factory
  static void _validateSandProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.sand) {
      if (cell.productionCenter != null && cell.productionCenter!.type == ProductionCenterType.factory) {
        throw AssertionError("Sand cell [${cell.row}; ${cell.col}] can't contain a factory");
      }
    }
  }

  // Sand can't contain a trench and a landFort
  static void _validateSandTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.sand) {
      if (cell.terrainModifier != null &&
          (cell.terrainModifier!.type == TerrainModifierType.trench ||
              cell.terrainModifier!.type == TerrainModifierType.landFort)) {
        throw AssertionError("Sand cell [${cell.row}; ${cell.col}] can't contain a trench and a landFort");
      }
    }
  }

  // Hills can't contain an air field
  static void _validateHillsProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.hills) {
      if (cell.productionCenter != null && cell.productionCenter!.type == ProductionCenterType.airField) {
        throw AssertionError("Hills cell [${cell.row}; ${cell.col}] can't contain an air field");
      }
    }
  }

  // Hills can't contain a mine field
  static void _validateHillsTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.hills) {
      if (cell.terrainModifier != null && cell.terrainModifier!.type == TerrainModifierType.landMine) {
        throw AssertionError("Hills cell [${cell.row}; ${cell.col}] can't contain a mine field");
      }
    }
  }

  // Mountains can't contain any production center
  static void _validateMountainsProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.mountains) {
      if (cell.productionCenter != null) {
        throw AssertionError("Mountains cell [${cell.row}; ${cell.col}] can't contain any production center");
      }
    }
  }

  // Mountains can't contain a minefield, a trench and a barbedWire
  static void _validateMountainsTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.mountains) {
      if (cell.terrainModifier != null &&
          (cell.terrainModifier!.type == TerrainModifierType.landMine ||
              cell.terrainModifier!.type == TerrainModifierType.trench ||
              cell.terrainModifier!.type == TerrainModifierType.barbedWire)) {
        throw AssertionError("Mountains can't contain a minefield, a trench and a barbedWire");
      }
    }
  }

  // Mountains can contain an infantry only
  static void _validateMountainsUnits(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.mountains) {
      if (cell.units.isNotEmpty && cell.units.any((u) => u.type != UnitType.infantry)) {
        throw AssertionError("Mountains cell [${cell.row}; ${cell.col}] can contain an infantry only");
      }
    }
  }

  // Snow can't contain an air field
  static void _validateSnowMountainsProductionCenters(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.snow) {
      if (cell.productionCenter != null && cell.productionCenter!.type == ProductionCenterType.airField) {
        throw AssertionError("Snow cell [${cell.row}; ${cell.col}] can't contain an air field");
      }
    }
  }

  // Snow can't contain a minefield
  static void _validateSnowTerrainModifiers(GameFieldCell cell) {
    if (cell.terrain == CellTerrain.snow) {
      if (cell.terrainModifier != null && cell.terrainModifier!.type == TerrainModifierType.landMine) {
        throw AssertionError("Snow cell [${cell.row}; ${cell.col}] can't contain a minefield");
      }
    }
  }
}
