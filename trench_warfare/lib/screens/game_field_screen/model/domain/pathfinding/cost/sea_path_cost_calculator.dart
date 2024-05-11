part of pathfinding;

abstract interface class PathCostCalculator {
  Iterable<GameFieldCell> calculate();

  bool isEndOfPathReachable();
}

class SeaPathCostCalculator implements PathCostCalculator {
  late final Iterable<GameFieldCell> _sourcePath;

  @protected
  late final Unit _activeUnit;

  @protected
  Nation get nation => _sourcePath.first.nation!;

  SeaPathCostCalculator(Iterable<GameFieldCell> sourcePath, Unit activeUnit) {
    _sourcePath = sourcePath;
    _activeUnit = activeUnit;
  }

  @override
  Iterable<GameFieldCell> calculate() {
    var movementPointsLeft = _activeUnit.movementPoints;

    var pathIsActive = true;

    for (var cell in _sourcePath) {
      if (cell == _sourcePath.first) {
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

    return _sourcePath;
  }

  @override
  bool isEndOfPathReachable() {
    var movementPointsLeft = _activeUnit.movementPoints;

    for (var cell in _sourcePath) {
      if (cell == _sourcePath.first) {
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
      _activeUnit.type != UnitType.carrier && cell.activeUnit != null && cell.nation != nation;

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.seaMine;
}
