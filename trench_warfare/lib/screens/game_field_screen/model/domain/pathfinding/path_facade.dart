part of pathfinding;

class PathFacade {
  static Iterable<GameFieldCell> calculatePath({
    required GameFieldRead gameField,
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) {
    final settings = startCell.isLand ? LandFindPathSettings(startCell: startCell) : SeaFindPathSettings(startCell: startCell);

    final pathFinder = FindPath(gameField, settings);
    return pathFinder.find(startCell, endCell);
  }

  static Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) {
    if (path.isEmpty) {
      return path;
    }

    return (path.first.isLand ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).calculate();
  }

  static bool canMove(GameFieldRead gameField, GameFieldCell cell) {
    final allCellsAround = gameField.findCellsAround(cell);

    for (var cellAround in allCellsAround) {
      final settings = cell.isLand ? LandFindPathSettings(startCell: cell) : SeaFindPathSettings(startCell: cell);
      final path = FindPath(gameField, settings).find(cell, cellAround);

      if (path.isEmpty) {
        continue;
      }

      if ((cell.isLand ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }

  static Iterable<GameFieldCell> getCellsAround(GameFieldRead gameField, GameFieldCell cell) =>
      gameField.findCellsAround(cell);
}
