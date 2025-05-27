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

abstract interface class PathCostCalculator {
  Iterable<GameFieldCell> calculate();

  bool isEndOfPathReachable();
}

class SeaPathCostCalculator implements PathCostCalculator {
  late final Iterable<GameFieldCellRead> _sourcePath;

  @protected
  late final _calculatedPath = _sourcePath.map((c) => c as GameFieldCell).toList(growable: false);

  @protected
  late final Unit _calculatedUnit;

  @protected
  Nation get nation => _sourcePath.first.nation!;

  SeaPathCostCalculator(Iterable<GameFieldCellRead> sourcePath, {required Unit calculatedUnit,}) {
    _sourcePath = sourcePath;
    _calculatedUnit = calculatedUnit;
  }

  @override
  Iterable<GameFieldCell> calculate() {
    var movementPointsLeft = _calculatedUnit.movementPoints;

    var pathIsActive = true;

    for (var cell in _calculatedPath) {
      if (cell == _calculatedPath.first) {
        cell.setPathItem(PathItem(
          type: PathItemType.normal,
          isActive: movementPointsLeft >= 0 && pathIsActive,
          movementPointsLeft: movementPointsLeft,
        ));
        continue;
      }

      final pathItemType = getPathItemType(cell, cell == _sourcePath.last);

      if (mustResetMovementPoints(cell) && movementPointsLeft > 0) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= getMoveToCellCost(cell);
      }

      cell.setPathItem(PathItem(
        type: pathItemType,
        isActive: movementPointsLeft >= 0 && pathIsActive,
        movementPointsLeft: movementPointsLeft,
      ));

      pathIsActive = pathIsActive && !mustDeactivateNextPath(cell);
    }

    return _calculatedPath;
  }

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

  @protected
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

  @protected
  bool mustResetMovementPoints(GameFieldCell nextCell) => false;

  @protected
  bool mustDeactivateNextPath(GameFieldCell nextCell) => isMineField(nextCell) || isBattleCell(nextCell);

  @protected
  double getMoveToCellCost(GameFieldCell nextCell) => 1;

  @protected
  bool isBattleCell(GameFieldCell cell) =>
      _calculatedUnit.type != UnitType.carrier && cell.activeUnit != null && cell.nation != nation;

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.seaMine;
}
