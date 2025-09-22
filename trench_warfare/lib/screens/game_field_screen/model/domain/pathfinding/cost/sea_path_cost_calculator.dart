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
  });

  @override
  bool isEndOfPathReachable() {
    var movementPointsLeft = _calculatedUnit.movementPoints;

    for (var cell in _calculatedPath) {
      if (cell == _calculatedPath.first) {
        continue;
      }

      if (mustResetMovementPoints(cell) && movementPointsLeft > 0) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= getMoveToCellCost(cell);
      }
    }

    return movementPointsLeft >= 0;
  }

  @override
  PathItemType getPathItemType(GameFieldCell nextCell, bool isLast) {
    if (isMineField(nextCell)) {
      return PathItemType.explosion;
    }

    if (isBattleCell(nextCell)) {
      return PathItemType.battle;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  @override
  bool mustResetMovementPoints(GameFieldCell nextCell) => false;

  @override
  bool mustDeactivateNextPath(GameFieldCell nextCell) => isMineField(nextCell) || isBattleCell(nextCell);

  @override
  double getMoveToCellCost(GameFieldCell nextCell) => 1;

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.seaMine;
}
