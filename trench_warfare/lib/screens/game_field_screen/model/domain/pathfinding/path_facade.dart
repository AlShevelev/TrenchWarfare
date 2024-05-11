part of pathfinding;

class PathFacade {
  static Iterable<GameFieldCell> calculatePath({
    required GameFieldRead gameField,
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) {
    final pathFinder = FindPath(gameField, _getFindPathSettings(startCell, endCell));
    return pathFinder.find(startCell, endCell);
  }

  static Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) {
    if (path.isEmpty) {
      return path;
    }
    return _getPathCostCalculator(path, startCell: path.first, endCell: path.last).calculate();
  }

  static bool canMove(GameFieldRead gameField, GameFieldCell startCell) {
    final allCellsAround = gameField.findCellsAround(startCell);

    for (var endCell in allCellsAround) {
      final path = FindPath(gameField, _getFindPathSettings(startCell, endCell)).find(startCell, endCell);

      if (path.isEmpty) {
        continue;
      }

      if (_getPathCostCalculator(path, startCell: startCell,  endCell: endCell).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }

  static Iterable<GameFieldCell> getCellsAround(GameFieldRead gameField, GameFieldCell cell) =>
      gameField.findCellsAround(cell);

  static FindPathSettings _getFindPathSettings(GameFieldCell startCell, GameFieldCell endCell) {
    final calculatedUnit = startCell.activeUnit!;

    if (calculatedUnit.isLand) {
      return LandFindPathSettings(startCell: startCell, calculatedUnit: calculatedUnit);
    }

    if (calculatedUnit is Carrier && calculatedUnit.units.isNotEmpty && endCell.isLand && !endCell.hasRiver) {
      return LandFindPathSettings(startCell: startCell, calculatedUnit: calculatedUnit.activeUnit);
    }

    return SeaFindPathSettings(startCell: startCell);
  }

  static PathCostCalculator _getPathCostCalculator(
    Iterable<GameFieldCell> path, {
    required GameFieldCell startCell,
    required GameFieldCellRead endCell,
  }) {
    final calculatedUnit = startCell.activeUnit!;

    if (calculatedUnit.isLand) {
      return LandPathCostCalculator(path, calculatedUnit);
    }

    if (calculatedUnit is Carrier && calculatedUnit.units.isNotEmpty && endCell.isLand && !endCell.hasRiver) {
      return LandPathCostCalculator(path, calculatedUnit.activeUnit!);
    }

    return SeaPathCostCalculator(path, calculatedUnit);
  }
}
