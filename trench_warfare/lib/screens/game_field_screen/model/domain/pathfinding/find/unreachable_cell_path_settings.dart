part of pathfinding;

class UnreachableCellPathSettings implements FindPathSettings {
  @override
  double? calculateGFactorHeuristic(GameFieldCellRead priorCell, GameFieldCellRead nextCell) => 1;

  @override
  bool isCellReachable(GameFieldCellRead cell) => false;
}
