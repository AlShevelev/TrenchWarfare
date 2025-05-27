/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of build_calculators;

class TerrainModifierBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  TerrainModifierBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError() => AppropriateCell();

  bool canBuildOnCell(GameFieldCellRead cell, TerrainModifierType type) {
    if (!_canBuildOnCellByTerrainType(cell, type)) {
      return false;
    }

    // bridge
    if (cell.hasRoad && cell.hasRiver && type != TerrainModifierType.landMine) {
      return false;
    }

    if (cell.hasRiver) {
      if (type == TerrainModifierType.antiAirGun ||
          type == TerrainModifierType.barbedWire ||
          type == TerrainModifierType.landFort ||
          type == TerrainModifierType.trench) {
        return false;
      }
    }

    switch (type) {
      case TerrainModifierType.trench:
      case TerrainModifierType.landFort:
      case TerrainModifierType.barbedWire:
      case TerrainModifierType.antiAirGun:
        {
          if (cell.nation != _myNation ||
              cell.terrainModifier != null ||
              cell.productionCenter != null) {
            return false;
          }

          return true;
        }
      case TerrainModifierType.landMine:
        {
          if (cell.nation != _myNation ||
              !cell.isLand ||
              cell.terrainModifier != null ||
              cell.productionCenter != null) {
            return false;
          }

          if (cell.activeUnit != null) {
            return false;
          }

          return true;
        }
      case TerrainModifierType.seaMine:
        {
          if (cell.nation != _myNation || cell.terrainModifier != null || cell.productionCenter != null) {
            return false;
          }

          if (cell.isLand && !cell.hasRiver) {
            return false;
          }

          if (cell.activeUnit != null) {
            return false;
          }

          return true;
        }
    }
  }

  bool canBuildOnGameField(TerrainModifierType type) {
    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, type)) {
        return true;
      }
    }

    return false;
  }

  /// Returns all the cells where we can build a terrain modifier
  /// (excluding money calculations)
  List<GameFieldCellRead> getAllCellsToBuild(TerrainModifierType type) =>
      _gameField.cells.where((c) => canBuildOnCell(c, type)).toList(growable: false);

  /// Returns all the cells where we can build or upgrade the terrain modifier
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsPossibleToBuild(TerrainModifierType type, MoneyUnit nationMoney) {
    final allImpossibleIds = getAllCellsImpossibleToBuild(type, nationMoney).map((c) => c.id).toSet();
    return _gameField.cells.where((c) => !allImpossibleIds.contains(c.id)).toList(growable: false);
  }

  /// Returns all the cells where we can't build the terrain modifier
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsImpossibleToBuild(TerrainModifierType type, MoneyUnit nationMoney) {
    return _gameField.cells.where((c) {
      final buildCost = MoneyTerrainModifierCalculator.calculateBuildCost(c.terrain, type);
      final cantBuild = !canBuildOnCell(c, type);

      if (buildCost == null) {
        return cantBuild;
      } else {
        return nationMoney.currency < buildCost.currency ||
            nationMoney.industryPoints < buildCost.industryPoints ||
            cantBuild;
      }
    }).toList(growable: false);
  }

  bool _canBuildOnCellByTerrainType(GameFieldCellRead cell, TerrainModifierType type) {
    switch (cell.terrain) {
      case CellTerrain.plain:
        {
          if (type == TerrainModifierType.seaMine && !cell.hasRiver) {
            return false;
          } else {
            return true;
          }
        }
      case CellTerrain.wood:
        return type == TerrainModifierType.trench;
      case CellTerrain.marsh:
        return type == TerrainModifierType.antiAirGun || type == TerrainModifierType.landMine;
      case CellTerrain.sand:
        return type == TerrainModifierType.barbedWire ||
            type == TerrainModifierType.antiAirGun ||
            type == TerrainModifierType.landMine;
      case CellTerrain.hills:
        return type == TerrainModifierType.trench ||
            type == TerrainModifierType.barbedWire ||
            type == TerrainModifierType.landFort ||
            type == TerrainModifierType.antiAirGun;
      case CellTerrain.mountains:
        return type == TerrainModifierType.landFort || type == TerrainModifierType.antiAirGun;
      case CellTerrain.snow:
        return type == TerrainModifierType.trench ||
            type == TerrainModifierType.barbedWire ||
            type == TerrainModifierType.landFort ||
            type == TerrainModifierType.antiAirGun;
      case CellTerrain.water:
        return type == TerrainModifierType.seaMine;
    }
  }
}
