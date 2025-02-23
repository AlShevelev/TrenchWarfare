part of movement;

/// Move from the start to the end without obstacles
class MovementWithoutObstaclesCalculator extends MovementCalculator {
  MovementWithoutObstaclesCalculator({
    required super.nation,
    required super.gameField,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
    required super.animationTime,
    required super.movementResultBridge,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final startUnit = path.first.activeUnit!;

    final detachResult = _detachActiveUnit(path);

    Logger.info(
      'WITHOUT_OBSTACLES; from: ${path.first}; to: ${path.last}; total: ${path.length}; unit: ${detachResult.unit}',
      tag: 'MOVEMENT',
    );

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    if (lastReachableCell == path.first) {
      _attachUnitAsActive(lastReachableCell, detachResult.unit);

      detachResult.unit.setMovementPoints(0);
      detachResult.unit.setState(UnitState.disabled);

      // We must make the unit very last to prevent blocking all units on the cell
      if (detachResult.unit.state == UnitState.disabled) {
        lastReachableCell.makeActiveUnitLast();
      }

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _updateUIForStandingUnit(path: path, reachableCells: reachableCells, unit: detachResult.unit);

      Logger.info(
        'WITHOUT_OBSTACLES; lastReachableCell == path.first; Canceled',
        tag: 'MOVEMENT',
      );
    } else {
      _movementResultBridge?.addBefore(
        nation: _nation,
        unit: Unit.copy(startUnit),
        cell: path.first,
      );

      GameFieldCell? cellWithCapturedPC;

      for (var cell in reachableCells) {
        if (cell.nation != _nation && cell.productionCenter != null) {
          cellWithCapturedPC = cell;
        }

        cell.setNation(_nation);
      }

      _attachUnitAsActive(lastReachableCell, detachResult.unit);

      detachResult.unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);

      Logger.info(
        'WITHOUT_OBSTACLES; unit.movementPoints: ${detachResult.unit.movementPoints}',
        tag: 'MOVEMENT',
      );

      if (detachResult.unit.movementPoints > 0) {
        final state = _canMove(startCell: lastReachableCell) && lastReachableCell == path.last
            ? UnitState.enabled
            : UnitState.disabled;
        detachResult.unit.setState(state);
      } else {
        detachResult.unit.setState(UnitState.disabled);
      }

      // We must make the unit very last to prevent blocking all units on the cell
      if (detachResult.unit.state == UnitState.disabled) {
        lastReachableCell.makeActiveUnitLast();
      }

      Logger.info('WITHOUT_OBSTACLES; new unit state is: ${detachResult.unit.state}', tag: 'MOVEMENT');

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _movementResultBridge?.addAfter(
        nation: _nation,
        unit: Unit.copy(detachResult.unit),
        cell: lastReachableCell,
      );

      if (detachResult.detachedFrom != null) {
        _movementResultBridge?.addAfter(
          nation: _nation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _updateUIForMovingUnit(
        path: path,
        reachableCells: reachableCells,
        cellWithCapturedPC: cellWithCapturedPC,
        unit: detachResult.unit,
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
          updateEvents.add(PlaySound(type: SoundType.battleResultPcCaptured));
        }

        updateEvents.add(UpdateCell(priorCell, updateBorderCells: _gameField.findCellsAround(priorCell)));
        updateEvents.add(Pause(_animationTime.unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(RemoveUntiedUnit(unit));

    updateEvents.add(UpdateCell(
      reachableCells.last,
      updateBorderCells: _gameField.findCellsAround(reachableCells.last),
    ));

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
