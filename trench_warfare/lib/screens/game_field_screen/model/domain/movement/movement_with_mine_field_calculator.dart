part of movement;

/// Move through a mine field
class MovementWithMineFieldCalculator extends MovementCalculator {
  static const minPossibleDamage = 0.5; // of a unit's max health value
  static const maxPossibleDamage = 1.0; // of a unit's max health value

  MovementWithMineFieldCalculator({
    required super.myNation,
    required super.humanNation,
    required super.gameField,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
    required super.animationTime,
    required super.movementResultBridge,
    required super.pathFacade,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final startUnit = path.first.activeUnit!;

    final detachResult = _detachActiveUnit(path);

    Logger.info(
      'MINE_FIELD; from: ${path.first}; to: ${path.last}; total: ${path.length}; unit: ${detachResult.unit}',
      tag: 'MOVEMENT',
    );

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    if (lastReachableCell == path.first) {
      _attachUnitAsActive(lastReachableCell, detachResult.unit);

      detachResult.unit.setMovementPoints(0);
      detachResult.unit.setState(UnitState.disabled);

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _updateUIForStandingUnit(
        path: path,
        reachableCells: reachableCells,
        unit: detachResult.unit,
      );

      Logger.info(
        'MINE_FIELD; lastReachableCell == path.first; Cancelled',
        tag: 'MOVEMENT',
      );
    } else {
      _movementResultBridge?.addBefore(
        nation: _myNation,
        unit: Unit.copy(startUnit),
        cell: path.first,
      );

      for (var cell in reachableCells) {
        cell.setNation(_myNation);
      }

      final damage = _calculateExplosionDamage(detachResult.unit);

      // the mine field is removed
      lastReachableCell.setTerrainModifier(null);

      final isUnitAlive = damage < detachResult.unit.health;

      Logger.info(
        'MINE_FIELD; isUnitAlive: $isUnitAlive',
        tag: 'MOVEMENT',
      );

      if (isUnitAlive) {
        lastReachableCell.addUnitAsActive(detachResult.unit);

        detachResult.unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);
        detachResult.unit.setHealth(detachResult.unit.health - damage);

        if (detachResult.unit.movementPoints > 0) {
          final state = _canMove(startCell: lastReachableCell) ? UnitState.enabled : UnitState.disabled;
          detachResult.unit.setState(state);
        } else {
          detachResult.unit.setState(UnitState.disabled);
        }

        _movementResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.unit),
          cell: lastReachableCell,
        );

        Logger.info(
          'MINE_FIELD; unit.health: ${detachResult.unit.health}; unit.movementPoints: ${detachResult.unit.movementPoints}; '
          'unit.state: ${detachResult.unit.state}',
          tag: 'MOVEMENT',
        );
      }

      for (var cell in path) {
        cell.setPathItem(null);
      }

      if (detachResult.detachedFrom != null) {
        _movementResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _updateUIForMovingUnit(
        path: path,
        reachableCells: reachableCells,
        unit: detachResult.unit,
        isUnitAlive: isUnitAlive,
      );
    }

    return _getNextState();
  }

  double _calculateExplosionDamage(Unit unit) {
    final min = unit.maxHealth * minPossibleDamage;
    final max = unit.maxHealth * maxPossibleDamage;

    final result = RandomGen.randomDouble(min, max);

    Logger.info(
      'MINE_FIELD; Damage calculation; unit.maxHealth: ${unit.maxHealth}; min: $min; max: $max; result: $result',
      tag: 'MOVEMENT',
    );

    return result;
  }

  void _updateUIForMovingUnit({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required Unit unit,
    required bool isUnitAlive,
  }) {
    // setup untied unit
    var updateEvents = [
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
        updateEvents.add(UpdateCell(priorCell, updateBorderCells: _gameField.findCellsAround(priorCell)));
        updateEvents.add(Pause(_animationTime.unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(PlaySound(
      type: SoundType.attackExplosion,
      duration: isUnitAlive ? null : _animationTime.damageAnimationTime,
    ));

    if (!isUnitAlive) {
      updateEvents.add(PlaySound(
        type: unit.getDeathSoundType(),
        strategy: SoundStrategy.putToQueue,
      ));
    }

    updateEvents.add(
      ShowDamage(
        cell: reachableCells.last,
        damageType: DamageType.explosion,
        time: _animationTime.damageAnimationTime,
      ),
    );

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
