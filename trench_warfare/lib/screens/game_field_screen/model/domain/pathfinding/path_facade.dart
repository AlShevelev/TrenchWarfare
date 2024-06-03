part of pathfinding;

class PathFacade {
  late final GameFieldRead _gameField;

  PathFacade(GameFieldRead gameField) {
    _gameField = gameField;
  }

  Iterable<GameFieldCell> calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) {
    final pathFinder = FindPath(
        _gameField,
        _getFindPathSettings(
          startCell.activeUnit!,
          startCell: startCell,
          endCell: endCell,
        ));
    return pathFinder.find(startCell, endCell);
  }

  Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) {
    if (path.isEmpty) {
      return path;
    }

    final startCell = path.first;
    return _getPathCostCalculator(
      startCell.activeUnit!,
      path,
      startCell: startCell,
      endCell: path.last,
    ).calculate();
  }

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

  int? canReach(Unit unit, {required GameFieldCell startCell, required GameFieldCell endCell}) {
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
    required GameFieldCell startCell,
    required GameFieldCell endCell,
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
    Iterable<GameFieldCell> path, {
    required GameFieldCell startCell,
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
