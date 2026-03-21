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

class SeaPathCostCalculator extends PathCostCalculatorBase {

  SeaPathCostCalculator(
    super.sourcePath, {
    required super.calculatedUnit,
    required super.settings,
  });

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
      return PathItemType.explosion;
    }

    if (isBattleCell(nextCell)) {
      return PathItemType.battle;
    }

    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return PathItemType.battleNextUnreachableCell;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  @override
  bool mustResetMovementPoints(GameFieldCell nextCell, {required bool isLast}) {
    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return true;
    }

    return false;
  }

  @override
  bool mustDeactivateNextPath(GameFieldCell nextCell) => isMineField(nextCell) || isBattleCell(nextCell);

  @override
  double getMoveToCellCost(GameFieldCell nextCell, {required bool isLast}) {
    if (isLast && _settings.isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return 0;
    }

    return 1;
  }

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.seaMine;
}
