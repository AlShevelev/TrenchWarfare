part of pathfinding;

class PathFacade {
  late final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  PathFacade(
    GameFieldRead gameField,
    Nation myNation,
    MapMetadataRead metadata,
  )   : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata;

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

  bool canMove(GameFieldCellRead startCell) => canMoveForUnit(startCell, startCell.activeUnit!);

  /// Can we move to any cell from a current one?
  bool canMoveForUnit(GameFieldCellRead startCell, Unit unit) {
    final allCellsAround = _gameField.findCellsAround(startCell);

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
      return LandFindPathSettings(
        startCell: startCell,
        calculatedUnit: calculatedUnit,
        myNation: _myNation,
        metadata: _metadata,
      );
    }

    if (_checkUnloadConditions(calculatedUnit, endCell)) {
      return LandFindPathSettings(
        startCell: startCell,
        calculatedUnit: (calculatedUnit as Carrier).activeUnit!,
        myNation: _myNation,
        metadata: _metadata,
      );
    }

    return SeaFindPathSettings(
      startCell: startCell,
      calculatedUnit: calculatedUnit,
      myNation: _myNation,
      metadata: _metadata,
    );
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
      return LandPathCostCalculator(
        path,
        calculatedUnit: calculatedUnit,
      );
    }

    if (_checkUnloadConditions(calculatedUnit, endCell)) {
      final calculatedCarrier = (calculatedUnit as Carrier);
      return LandPathCostCalculator(
        path,
        calculatedUnit: calculatedCarrier.activeUnit!,
        calculatedCarrier: calculatedCarrier,
      );
    }

    return SeaPathCostCalculator(path, calculatedUnit: calculatedUnit);
  }

  bool _checkUnloadConditions(Unit calculatedUnit, GameFieldCellRead endCell) =>
      calculatedUnit is Carrier &&
      calculatedUnit.units.isNotEmpty &&
      endCell.isLand &&
      !endCell.hasRiver &&
      (endCell.terrain == CellTerrain.plain ||
          endCell.terrain == CellTerrain.wood ||
          endCell.terrain == CellTerrain.sand ||
          endCell.terrain == CellTerrain.hills ||
          endCell.terrain == CellTerrain.snow);

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
        calculatedUnit.type,
        _myNation,
        _metadata,
        startCell: startCell,
        cell: endCell,
      );
    }

    if (!calculatedUnit.isLand) {
      if (!startCell.isLand || (startCell.isLand && startCell.hasRiver)) {
        return !SeaFindPathSettings.isCellReachableStatic(
          calculatedUnit.type,
          _myNation,
          _metadata,
          startCell: startCell,
          cell: endCell,
        );
      }
    }

    return false;
  }
}
