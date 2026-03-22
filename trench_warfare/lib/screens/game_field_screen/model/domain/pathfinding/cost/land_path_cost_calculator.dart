/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of pathfinding;

class LandPathCostCalculator extends PathCostCalculatorBase {
  bool _unloadUnitPathItemExists = false;

  bool _explosionOrBattlePathItemExists = false;

  final Carrier? _calculatedCarrier;

  LandPathCostCalculator(
    super.sourcePath, {
    required super.calculatedUnit,
    required super.settings,
    Carrier? calculatedCarrier,
  }) : _calculatedCarrier = calculatedCarrier;

  @override
  bool isEndOfPathReachable() {
    var movementPointsLeft = _calculatedUnit.movementPoints;

    for (var cell in _calculatedPath) {
      if (cell == _calculatedPath.first) {
        continue;
      }

      final isLast = cell == _sourcePath.last;

      final moveToCellCost = getMoveToCellCost(cell, isLast: isLast);

      if (mustResetMovementPoints(cell, isLast: isLast) && movementPointsLeft > moveToCellCost) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= moveToCellCost;
      }
    }

    return movementPointsLeft >= 0;
  }

  @override
  PathItemType getPathItemType(GameFieldCell nextCell, {required bool isLast}) {
    if (isMineField(nextCell)) {
      _explosionOrBattlePathItemExists = true;
      return PathItemType.explosion;
    }

    if (_isMyCarrier(nextCell)) {
      return PathItemType.loadUnit;
    }

    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      _explosionOrBattlePathItemExists = true;
      return PathItemType.battleNextUnreachableCell;
    }

    if (isBattleCell(nextCell)) {
      _explosionOrBattlePathItemExists = true;
      return PathItemType.battle;
    }

    if (_calculatedCarrier != null && !_unloadUnitPathItemExists && !_explosionOrBattlePathItemExists) {
      _unloadUnitPathItemExists = true;
      return PathItemType.unloadUnit;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  // rivers (without bridges), enemy trench, enemy barbed wire (except tanks), carriers
  // & when an unreachable cell is attacked by our artillery
  @override
  bool mustResetMovementPoints(GameFieldCell nextCell, {required bool isLast}) {
    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return true;
    }

    if (nextCell.hasRiver && !nextCell.hasRoad) {
      return true;
    }

    if (_isMyCarrier(nextCell)) {
      return true;
    }

    if (nextCell.nation != myNation) {
      if (nextCell.terrainModifier?.type == TerrainModifierType.trench) {
        return true;
      }

      if (nextCell.terrainModifier?.type == TerrainModifierType.barbedWire &&
          _calculatedUnit.type != UnitType.tank) {
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
  double getMoveToCellCost(GameFieldCell nextCell, {required bool isLast}) {
    if (nextCell.hasRoad) {
      return 1;
    }

    if (nextCell.productionCenter != null) {
      return 1;
    }

    if (_isMyCarrier(nextCell)) {
      return 1;
    }

    final cost = switch (nextCell.terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (_calculatedUnit.type) {
          UnitType.infantry => 1.25,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 2,
          UnitType.artillery => 2,
          UnitType.armoredCar => 2,
          UnitType.tank => 2,
          _ => double.maxFinite,
        },
      CellTerrain.marsh => switch (_calculatedUnit.type) {
          UnitType.infantry => 2,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 2,
          _ => double.maxFinite,
        },
      CellTerrain.sand => switch (_calculatedUnit.type) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 1.7,
          UnitType.artillery => 2,
          UnitType.armoredCar => 1.7,
          UnitType.tank => 1.25,
          _ => double.maxFinite,
        },
      CellTerrain.hills => switch (_calculatedUnit.type) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => double.maxFinite,
        },
      CellTerrain.mountains => switch (_calculatedUnit.type) {
          UnitType.infantry => 2,
          _ => double.maxFinite
        },
      CellTerrain.snow => switch (_calculatedUnit.type) {
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

    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return 0;
    }

    return cost * GameConstants.landMovementSpeedFactor;
  }

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.landMine;

  @protected
  bool _isMyCarrier(GameFieldCell cell) => cell.nation == myNation && cell.activeUnit is Carrier;
}
