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
    switch(type) {
      case TerrainModifierType.trench:
      case TerrainModifierType.landFort:
      case TerrainModifierType.barbedWire:
      case TerrainModifierType.antiAirGun: {
        if (cell.nation != _myNation || !cell.isLand || cell.hasRiver || cell.terrainModifier != null || cell.productionCenter != null ) {
          return false;
        }

        final activeUnit = cell.activeUnit;
        if (activeUnit == null || activeUnit.type != UnitType.infantry || activeUnit.movementPoints != activeUnit.maxMovementPoints) {
          return false;
        }

        return true;
      }
      case TerrainModifierType.landMine: {
        if (cell.nation != _myNation || !cell.isLand || cell.terrainModifier != null || cell.productionCenter != null ) {
          return false;
        }

        if (cell.activeUnit != null) {
          return false;
        }

        return true;
      }
      case TerrainModifierType.seaMine: {
        if (cell.nation != _myNation || cell.terrainModifier != null || cell.productionCenter != null ) {
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

  List<GameFieldCellRead> getAllCellsToBuild(TerrainModifierType type) =>
    _gameField.cells.where((c) => canBuildOnCell(c, type)).toList(growable: false);

  List<GameFieldCellRead> getAllCellsImpossibleToBuild(TerrainModifierType type) =>
      _gameField.cells.where((c) => !canBuildOnCell(c, type)).toList(growable: false);
}