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
  Nation get myNation => _sourcePath.first.nation!;

  @protected
  final FindPathSettings _settings;

  PathCostCalculatorBase(
    Iterable<GameFieldCellRead> sourcePath, {
    required Unit calculatedUnit,
    required FindPathSettings settings,
  })  : _sourcePath = sourcePath,
        _settings = settings,
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

      final isLast = cell == _sourcePath.last;

      final pathItemType = getPathItemType(cell, isLast: isLast);

      if (mustResetMovementPoints(cell, isLast: isLast) && movementPointsLeft > 0) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= getMoveToCellCost(cell, isLast: isLast);
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
  bool isEndOfPathReachable();

  @protected
  PathItemType getPathItemType(GameFieldCell nextCell, {required bool isLast});

  @protected
  bool mustResetMovementPoints(GameFieldCell nextCell, {required bool isLast});

  @protected
  double getMoveToCellCost(GameFieldCell nextCell, {required bool isLast});

  @protected
  bool mustDeactivateNextPath(GameFieldCell nextCell);

  @protected
  bool isBattleCell(GameFieldCell cell) =>
      _calculatedUnit.type != UnitType.carrier && cell.activeUnit != null && cell.nation != myNation;
}
