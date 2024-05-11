part of pathfinding;

class LandPathCostCalculator extends SeaPathCostCalculator {
  bool unloadUnitPathItemExists = false;

  LandPathCostCalculator(super.sourcePath, super.activeUnit);

  @override
  PathItemType getPathItemType(GameFieldCell nextCell, bool isLast) {
    if (isMineField(nextCell)) {
      return PathItemType.explosion;
    }

    if (_isMyCarrier(nextCell)) {
      return PathItemType.loadUnit;
    }

    if (isBattleCell(nextCell)) {
      return PathItemType.battle;
    }

    if (_isMyCarrier(_sourcePath.first) && !unloadUnitPathItemExists) {
      unloadUnitPathItemExists = true;
      return PathItemType.unloadUnit;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  // rivers (without bridges), enemy trench, enemy barbed wire (except tanks), carriers
  @override
  bool mustResetMovementPoints(GameFieldCell nextCell) {
    if (nextCell.hasRiver && !nextCell.hasRoad) {
      return true;
    }

    if (_isMyCarrier(nextCell)) {
      return true;
    }

    if (nextCell.nation != nation) {
      if (nextCell.terrainModifier?.type == TerrainModifierType.trench) {
        return true;
      }

      if (nextCell.terrainModifier?.type == TerrainModifierType.barbedWire &&
          _activeUnit.type != UnitType.tank) {
        return true;
      }
    }

    return false;
  }

  @override
  bool mustDeactivateNextPath(GameFieldCell nextCell) =>
      isMineField(nextCell) || isBattleCell(nextCell) || _isMyCarrier(nextCell);

  // terrain & units, what else?
  @override
  double getMoveToCellCost(GameFieldCell nextCell) {
    if (nextCell.hasRoad) {
      return 1;
    }

    if (nextCell.productionCenter != null) {
      return 1;
    }

    if (_isMyCarrier(nextCell)) {
      return 1;
    }

    return switch (nextCell.terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (_activeUnit.type) {
          UnitType.infantry => 1.25,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 2,
          UnitType.artillery => 2,
          UnitType.armoredCar => 2,
          UnitType.tank => 2,
          _ => double.maxFinite,
        },
      CellTerrain.marsh => switch (_activeUnit.type) {
          UnitType.infantry => 2,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 2,
          _ => double.maxFinite,
        },
      CellTerrain.sand => switch (_activeUnit.type) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 1.7,
          UnitType.artillery => 2,
          UnitType.armoredCar => 1.7,
          UnitType.tank => 1.25,
          _ => double.maxFinite,
        },
      CellTerrain.hills => switch (_activeUnit.type) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => double.maxFinite,
        },
      CellTerrain.mountains => switch (_activeUnit.type) { UnitType.infantry => 2, _ => double.maxFinite },
      CellTerrain.snow => switch (_activeUnit.type) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => double.maxFinite,
        },
      _ => double.maxFinite,
    };
  }

  @override
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.landMine;

  bool _isMyCarrier(GameFieldCell cell) => cell.nation == nation && cell.activeUnit is Carrier;
}
