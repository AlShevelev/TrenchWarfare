part of movement;

/// Move from the start to the end without obstacles
class MovementWithoutObstaclesCalculator extends MovementCalculator {
  MovementWithoutObstaclesCalculator({
    required super.nation,
    required super.gameField,
    required super.updateGameObjectsEvent,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final unit = path.first.removeActiveUnit();

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    for (var cell in reachableCells) {
      cell.setNation(_nation);
    }

    lastReachableCell.addUnitAsActive(unit);
    unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);

    if (unit.movementPoints > 0) {
      final state = _canMove(startCell: lastReachableCell, isLandUnit: unit.isLand) ? UnitState.enabled : UnitState.disabled;
      unit.setState(state);
    } else {
      unit.setState(UnitState.disabled);
    }

    for (var cell in path) {
      cell.setPathItem(null);
    }

    _updateUI(path: path, reachableCells: reachableCells, unit: unit);

    return MovingInProgress();
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required Unit unit,
  }) {
    // setup untied unit
    final updateEvents = [
      CreateUntiedUnit(path.first, unit),
      UpdateCell(path.first, updateBorderCells: []),
    ];

    // move the unit
    GameFieldCell? priorCell;
    for (var cell in reachableCells) {
      if (cell != reachableCells.first) {
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: unit,
          time: MovementConstants.unitMovementTime,
        ));
        updateEvents.add(UpdateCell(cell, updateBorderCells: _gameField.findCellsAround(cell)));
        updateEvents.add(Pause(MovementConstants.unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(RemoveUntiedUnit(unit));

    // clear the rest of the path
    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateCell(cell, updateBorderCells: []));
      }
    }

    updateEvents.add(MovementCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }
}
