part of game_field_sm;

class FromPathIsShownOnClick extends TransitionBase {
  late final Nation _nation;

  static const int _unitMovementTime = 100; // [ms]
  static const int _unitMovementPause = 100; // [ms]

  FromPathIsShownOnClick(super.updateGameObjectsEvent, super.gameField, Nation nation) {
    _nation = nation;
  }

  State process(Iterable<GameFieldCell> path, GameFieldCell cell) {
    final firstCell = path.first;

    final unit = firstCell.activeUnit!;

    if (cell == path.first) {
      return _resetPathAndEnableUnit(path, unit);
    }

    if (cell == path.last) {
      return _startSimpleMovement(path);
    }

    // calculate a path
    Iterable<GameFieldCell> newPath = _calculatePath(startCell: firstCell, endCell: cell, isLandUnit: unit.isLand);

    if (newPath.isEmpty) {
      return _resetPathAndEnableUnit(path, unit);
    }

    _resetPath(path);

    // show the new path
    final estimatedPath = _estimatePath(path: newPath, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(newPath);
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _updateGameObjectsEvent.update(path.map((c) => UpdateObject(c)));
  }

  /// Clear the path and make the unit enabled
  State _resetPathAndEnableUnit(Iterable<GameFieldCell> path, Unit unit) {
    unit.setState(UnitState.enabled);
    _resetPath(path);
    return ReadyForInput();
  }

  /// Move from the start to the end without obstacles
  State _startSimpleMovement(Iterable<GameFieldCell> path) {
    final unit = path.first.removeActiveUnit();

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    for (var cell in reachableCells) {
      cell.setNation(_nation);
    }

    lastReachableCell.addUnitAsActive(unit);
    unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);

    if (unit.movementPoints > 0) {
      final state = canMove(startCell: lastReachableCell, isLandUnit: unit.isLand) ? UnitState.enabled : UnitState.disabled;
      unit.setState(state);
    } else {
      unit.setState(UnitState.disabled);
    }

    for (var cell in path) {
      cell.setPathItem(null);
    }

    // Here we must update UI
    var updateEvents = [
      CreateUntiedUnit(path.first, unit),
      UpdateObject(path.first),
    ];

    GameFieldCell? priorCell;
    for (var cell in reachableCells) {
      if (cell != reachableCells.first) {
        updateEvents.add(MoveUntiedUnit(startCell: priorCell!, endCell: cell, unit: unit, time: _unitMovementTime));
        updateEvents.add(UpdateObject(cell));
        updateEvents.add(Pause(_unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(RemoveUntiedUnit(unit));

    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateObject(cell));
      }
    }

    updateEvents.add(MovementCompleted());
    _updateGameObjectsEvent.update(updateEvents);

    return MovingInProgress();
  }
}