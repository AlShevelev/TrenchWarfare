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

class NextCellPathCostCalculator implements PathCostCalculator {
  late final Iterable<GameFieldCellRead> _sourcePath;

  late final _calculatedPath = _sourcePath.map((c) => c as GameFieldCell).toList(growable: false);

  NextCellPathCostCalculator(Iterable<GameFieldCellRead> sourcePath) {
    _sourcePath = sourcePath;
  }

  @override
  Iterable<GameFieldCell> calculate() {
    _calculatedPath.first.setPathItem(
      PathItem(
        type: PathItemType.normal,
        isActive: true,
        movementPointsLeft: 0, // It doesn't matter in this scenario
      ),
    );

    _calculatedPath.last.setPathItem(PathItem(
      type: PathItemType.battleNextUnreachableCell,
      isActive: true,
      movementPointsLeft: 0, // It doesn't matter in this scenario
    ));

    return _calculatedPath;
  }

  @override
  bool isEndOfPathReachable() => true;
}
