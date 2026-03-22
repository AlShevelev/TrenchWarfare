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

class UnreachableCellPathSettings implements FindPathSettings {
  @override
  double? calculateGFactorHeuristic({
    required GameFieldCellRead priorCell,
    required GameFieldCellRead nextCell,
    required GameFieldCellRead lastCell,
  }) => 1;

  @override
  bool isCellReachable(GameFieldCellRead cell) => false;

  @override
  bool isUnreachableEnemyCellReachableForArtilleryStrike(GameFieldCellRead nextCell) => false;
}
