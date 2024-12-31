part of movement;

/// Move from the start to the end without obstacles
class MovementWithoutObstaclesCalculator extends MovementCalculator {
  MovementWithoutObstaclesCalculator({
    required super.nation,
    required super.gameField,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
    required super.animationTime,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final unit = _detachActiveUnit(path);

    Logger.info(
      'WITHOUT_OBSTACLES; from: ${path.first}; to: ${path.last}; total: ${path.length}; unit: $unit',
      tag: 'MOVEMENT',
    );

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    if (lastReachableCell == path.first) {
      _attachUnit(lastReachableCell, unit);

      unit.setMovementPoints(0);
      unit.setState(UnitState.disabled);

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _updateUIForStandingUnit(path: path, reachableCells: reachableCells, unit: unit);

      Logger.info(
        'WITHOUT_OBSTACLES; lastReachableCell == path.first; Canceled',
        tag: 'MOVEMENT',
      );
    } else {
      GameFieldCell? cellWithCapturedPC;

      for (var cell in reachableCells) {
        if (cell.nation != _nation && cell.productionCenter != null) {
          cellWithCapturedPC = cell;
        }

        cell.setNation(_nation);
      }

      _attachUnit(lastReachableCell, unit);

      unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);

      Logger.info(
        'WITHOUT_OBSTACLES; unit.movementPoints: ${unit.movementPoints}',
        tag: 'MOVEMENT',
      );

      if (unit.movementPoints > 0) {
        final state = _canMove(startCell: lastReachableCell) && lastReachableCell == path.last
            ? UnitState.enabled
            : UnitState.disabled;
        unit.setState(state);
      } else {
        unit.setState(UnitState.disabled);
      }

      Logger.info('WITHOUT_OBSTACLES; new unit state is: ${unit.state}', tag: 'MOVEMENT');

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _updateUIForMovingUnit(
        path: path,
        reachableCells: reachableCells,
        cellWithCapturedPC: cellWithCapturedPC,
        unit: unit,
      );
    }

    return _getNextState();
  }

  void _updateUIForMovingUnit({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required GameFieldCell? cellWithCapturedPC,
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
        updateEvents.add(MoveCameraToCell(cell));
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: unit,
          time: _animationTime.unitMovementTime,
        ));

        if (cell == cellWithCapturedPC) {
          updateEvents.add(PlaySound(type: SoundType.battleResultCaptured, delayAfterPlay: 0));
        }

        updateEvents.add(UpdateCell(cell, updateBorderCells: _gameField.findCellsAround(cell)));
        updateEvents.add(Pause(_animationTime.unitMovementPause));
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

    updateEvents.add(AnimationCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }

  void _updateUIForStandingUnit({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required Unit unit,
  }) {
    // setup untied unit
    final updateEvents = [
      MoveCameraToCell(path.first),
      UpdateCell(path.first, updateBorderCells: []),
    ];

    // clear the rest of the path
    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateCell(cell, updateBorderCells: []));
      }
    }

    updateEvents.add(Pause(_animationTime.unitMovementPause));
    updateEvents.add(AnimationCompleted());

    _updateGameObjectsEvent.update(updateEvents);
  }
}
