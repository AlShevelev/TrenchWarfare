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

abstract class PathCostCalculatorBase implements PathCostCalculator {
  final Iterable<GameFieldCellRead> _sourcePath;

  final Unit _calculatedUnit;

  @protected
  late final _calculatedPath = _sourcePath.map((c) => c as GameFieldCell).toList(growable: false);

  @protected
  Nation get nation => _sourcePath.first.nation!;

  PathCostCalculatorBase(
      Iterable<GameFieldCellRead> sourcePath, {
        required Unit calculatedUnit,
      })  : _sourcePath = sourcePath,
        _calculatedUnit = calculatedUnit;

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
    // TODO: implement isEndOfPathReachable
    throw UnimplementedError();
  }

  @protected
  PathItemType getPathItemType(GameFieldCell nextCell, bool isLast);

  @protected
  bool mustResetMovementPoints(GameFieldCell nextCell);

  @protected
  double getMoveToCellCost(GameFieldCell nextCell);

  @protected
  bool mustDeactivateNextPath(GameFieldCell nextCell);

  @protected
  bool isBattleCell(GameFieldCell cell) =>
      _calculatedUnit.type != UnitType.carrier && cell.activeUnit != null && cell.nation != nation;
}