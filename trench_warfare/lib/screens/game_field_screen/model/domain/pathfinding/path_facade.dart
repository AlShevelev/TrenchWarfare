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
    final pathFinder = FindPath(_gameField, _getFindPathSettings(startCell, endCell));
    return pathFinder.find(startCell, endCell);
  }

  Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) {
    if (path.isEmpty) {
      return path;
    }
    return _getPathCostCalculator(path, startCell: path.first, endCell: path.last).calculate();
  }

  bool canMove(GameFieldCell startCell) {
    final allCellsAround = _gameField.findCellsAround(startCell);

    for (var endCell in allCellsAround) {
      final path = FindPath(_gameField, _getFindPathSettings(startCell, endCell)).find(startCell, endCell);

      if (path.isEmpty) {
        continue;
      }

      if (_getPathCostCalculator(path, startCell: startCell, endCell: endCell).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }

  Iterable<GameFieldCell> getCellsAround(GameFieldCell cell) => _gameField.findCellsAround(cell);

  FindPathSettings _getFindPathSettings(GameFieldCell startCell, GameFieldCell endCell) {
    final calculatedUnit = startCell.activeUnit!;

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
    Iterable<GameFieldCell> path, {
    required GameFieldCell startCell,
    required GameFieldCellRead endCell,
  }) {
    final calculatedUnit = startCell.activeUnit!;

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
