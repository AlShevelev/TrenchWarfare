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
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final unit = _detachActiveUnit(path);

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    for (var cell in reachableCells) {
      cell.setNation(_nation);
    }

    final damage = _calculateExplosionDamage(unit);

    // the mine field is removed
    lastReachableCell.setTerrainModifier(null);

    final isUnitAlive = damage < unit.health;

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
    }

    for (var cell in path) {
      cell.setPathItem(null);
    }

    _updateUI(path: path, reachableCells: reachableCells, unit: unit);

    return _getNextState();
  }

  double _calculateExplosionDamage(Unit unit) {
    final min = unit.maxHealth * minPossibleDamage;
    final max = unit.maxHealth * maxPossibleDamage;

    return RandomGen.randomDouble(min, max);
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required Unit unit,
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
          time: MovementConstants.unitMovementTime,
        ));
        updateEvents.add(UpdateCell(cell, updateBorderCells: _gameField.findCellsAround(cell)));
        updateEvents.add(Pause(MovementConstants.unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(ShowDamage(
      cell: reachableCells.last,
      damageType: DamageType.explosion,
      time: MovementConstants.damageAnimationTime,
    ));

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
}
