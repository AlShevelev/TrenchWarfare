part of movement;

/// Move through a mine field
class MovementWithMineFieldCalculator extends MovementCalculator {
  static const minPossibleDamage = 0.1; // of a unit's max health value
  static const maxPossibleDamage = 0.5; // of a unit's max health value

  MovementWithMineFieldCalculator({
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
      'MINE_FIELD; from: ${path.first}; to: ${path.last}; total: ${path.length}; unit: $unit',
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

      _updateUIForStandingUnit(
        path: path,
        reachableCells: reachableCells,
        unit: unit,
      );

      Logger.info(
        'MINE_FIELD; lastReachableCell == path.first; Cancelled',
        tag: 'MOVEMENT',
      );
    } else {
      for (var cell in reachableCells) {
        cell.setNation(_nation);
      }

      final damage = _calculateExplosionDamage(unit);

      // the mine field is removed
      lastReachableCell.setTerrainModifier(null);

      final isUnitAlive = damage < unit.health;

      Logger.info(
        'MINE_FIELD; isUnitAlive: $isUnitAlive',
        tag: 'MOVEMENT',
      );

      if (isUnitAlive) {
        lastReachableCell.addUnitAsActive(unit);

        unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);
        unit.setHealth(unit.health - damage);

        if (unit.movementPoints > 0) {
          final state = _canMove(startCell: lastReachableCell) ? UnitState.enabled : UnitState.disabled;
          unit.setState(state);
        } else {
          unit.setState(UnitState.disabled);
        }

        Logger.info(
          'MINE_FIELD; unit.health: ${unit.health}; unit.movementPoints: ${unit.movementPoints}; '
          'unit.state: ${unit.state}',
          tag: 'MOVEMENT',
        );
      }

      for (var cell in path) {
        cell.setPathItem(null);
      }

      _updateUIForMovingUnit(
        path: path,
        reachableCells: reachableCells,
        unit: unit,
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
        updateEvents.add(UpdateCell(cell, updateBorderCells: _gameField.findCellsAround(cell)));
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
