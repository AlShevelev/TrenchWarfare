part of pathfinding;

class NextCellPathCostCalculator implements PathCostCalculator {
  late final Iterable<GameFieldCell> _sourcePath;

  NextCellPathCostCalculator(Iterable<GameFieldCell> sourcePath) {
    _sourcePath = sourcePath;
  }

  @override
  Iterable<GameFieldCell> calculate() {
    _sourcePath.first.setPathItem(
        PathItem(
          type: PathItemType.normal,
          isActive: true,
          movementPointsLeft: 0,    // It doesn't matter in this scenario
        )
    );

    _sourcePath.last.setPathItem(
        PathItem(
          type: PathItemType.battleNextUnreachableCell,
          isActive: true,
          movementPointsLeft: 0,    // It doesn't matter in this scenario
        )
    );

    return _sourcePath;
  }

  @override
  bool isEndOfPathReachable() => true;
}