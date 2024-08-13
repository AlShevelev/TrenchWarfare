part of pathfinding;

class PathFacade {
  late final GameFieldRead _gameField;

  PathFacade(GameFieldRead gameField) {
    _gameField = gameField;
  }

  /// Calculates a path without estimation
  Iterable<GameFieldCellRead> calculatePath({
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
  }) =>
      calculatePathForUnit(
        startCell: startCell,
        endCell: endCell,
        calculatedUnit: startCell.activeUnit!,
      );

  /// Calculates a path without estimation for some unit
  Iterable<GameFieldCellRead> calculatePathForUnit({
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
    required Unit calculatedUnit,
  }) {
    final pathFinder = FindPath(
        _gameField,
        _getFindPathSettings(
          calculatedUnit,
          startCell: startCell,
          endCell: endCell,
        ));
    return pathFinder.find(startCell, endCell);
  }

  /// Estimates a path cost
  Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCellRead> path}) =>
      estimatePathForUnit(path: path, unit: path.first.activeUnit!);

  /// Estimates a path cost for the specific unit
  Iterable<GameFieldCell> estimatePathForUnit({
    required Iterable<GameFieldCellRead> path,
    required Unit unit,
  }) {
    if (path.isEmpty) {
      return path.map((i) => i as GameFieldCell).toList(growable: false);
    }

    return _getPathCostCalculator(
      unit,
      path,
      startCell: path.first,
      endCell: path.last,
    ).calculate();
  }

  /// Can we move to any cell from a current one?
  bool canMove(GameFieldCell startCell) {
    final allCellsAround = _gameField.findCellsAround(startCell);

    final unit = startCell.activeUnit!;

    for (var endCell in allCellsAround) {
      final path = FindPath(
          _gameField,
          _getFindPathSettings(
            unit,
            startCell: startCell,
            endCell: endCell,
          )).find(startCell, endCell);

      if (path.isEmpty) {
        continue;
      }

      if (_getPathCostCalculator(
        unit,
        path,
        startCell: startCell,
        endCell: endCell,
      ).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }

  /// Can we reach some cell by a unit?
  /// Returns a length of the path or null if the end cell is unreachable
  int? canReach(Unit unit, {required GameFieldCellRead startCell, required GameFieldCellRead endCell}) {
    final path = FindPath(
        _gameField,
        _getFindPathSettings(
          unit,
          startCell: startCell,
          endCell: endCell,
        )).find(startCell, endCell);

    if (path.isEmpty) {
      return null;
    }

    if (_getPathCostCalculator(
      unit,
      path,
      startCell: startCell,
      endCell: endCell,
    ).isEndOfPathReachable()) {
      return path.length;
    }

    return null;
  }

  Iterable<GameFieldCell> getCellsAround(GameFieldCell cell) => _gameField.findCellsAround(cell);

  FindPathSettings _getFindPathSettings(
    Unit calculatedUnit, {
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
  }) {
    if (_checkBattleNextUnreachableCellConditions(calculatedUnit, startCell, endCell)) {
      return NextCellPathSettings();
    }

    if (calculatedUnit.isLand) {
      return LandFindPathSettings(startCell: startCell, calculatedUnit: calculatedUnit);
    }

    if (_checkUnloadConditions(calculatedUnit, endCell)) {
      return LandFindPathSettings(
        startCell: startCell,
        calculatedUnit: (calculatedUnit as Carrier).activeUnit!,
      );
    }

    return SeaFindPathSettings(startCell: startCell);
  }

  PathCostCalculator _getPathCostCalculator(
    Unit calculatedUnit,
    Iterable<GameFieldCellRead> path, {
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
  }) {
    if (_checkBattleNextUnreachableCellConditions(calculatedUnit, startCell, endCell)) {
      return NextCellPathCostCalculator(path);
    }

    if (calculatedUnit.isLand) {
      return LandPathCostCalculator(path, calculatedUnit);
    }

    if (_checkUnloadConditions(calculatedUnit, endCell)) {
      return LandPathCostCalculator(path, (calculatedUnit as Carrier).activeUnit!);
    }

    return SeaPathCostCalculator(path, calculatedUnit);
  }

  bool _checkUnloadConditions(Unit calculatedUnit, GameFieldCellRead endCell) =>
      calculatedUnit is Carrier && calculatedUnit.units.isNotEmpty && endCell.isLand && !endCell.hasRiver;

  bool _checkBattleNextUnreachableCellConditions(
    Unit calculatedUnit,
    GameFieldCellRead startCell,
    GameFieldCellRead endCell,
  ) {
    if (endCell.nation == startCell.nation ||
        endCell.activeUnit == null ||
        !calculatedUnit.hasArtillery ||
        !_gameField.findCellsAround(startCell).contains(endCell)) {
      return false;
    }

    if (calculatedUnit.isLand && startCell.isLand) {
      return !LandFindPathSettings.isCellReachableStatic(
        startCell.activeUnit!.type,
        startCell: startCell,
        cell: endCell,
      );
    }

    if (!calculatedUnit.isLand) {
      if (!startCell.isLand || (startCell.isLand && startCell.hasRiver)) {
        return !SeaFindPathSettings.isCellReachableStatic(startCell: startCell, cell: endCell);
      }
    }

    return false;
  }
}
