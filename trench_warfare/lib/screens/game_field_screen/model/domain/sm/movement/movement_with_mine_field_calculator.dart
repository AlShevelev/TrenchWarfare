part of movement;

/// Move through a mine field
class MovementWithMineFieldCalculator extends MovementCalculator {
  static const minPossibleDamage = 0.1;   // of a unit's max health value
  static const maxPossibleDamage = 0.5;   // of a unit's max health value

  late final Nation _nation;
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementWithMineFieldCalculator({
    required Nation nation,
    required super.gameField,
    required SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _nation = nation;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final unit = path.first.removeActiveUnit();

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
        final state = _canMove(startCell: lastReachableCell, isLandUnit: unit.isLand) ? UnitState.enabled : UnitState.disabled;
        unit.setState(state);
      } else {
        unit.setState(UnitState.disabled);
      }
    }

    for (var cell in path) {
      cell.setPathItem(null);
    }

    _updateUI(path: path, reachableCells: reachableCells, unit: unit);

    return MovingInProgress();
  }

  double _calculateExplosionDamage(Unit unit) {
    final min = unit.maxHealth * minPossibleDamage;
    final max = unit.maxHealth * maxPossibleDamage;

    return Random().nextDouble() * (max - min) + min;
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required Iterable<GameFieldCell> reachableCells,
    required Unit unit,
  }) {
    var updateEvents = [
      CreateUntiedUnit(path.first, unit),
      UpdateObject(path.first),
    ];

    GameFieldCell? priorCell;
    for (var cell in reachableCells) {
      if (cell != reachableCells.first) {
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: unit,
          time: MovementConstants.unitMovementTime,
        ));
        updateEvents.add(UpdateObject(cell));
        updateEvents.add(Pause(MovementConstants.unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(ShowExplosion(unit: unit, time: MovementConstants.explosionTime));

    updateEvents.add(RemoveUntiedUnit(unit));

    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateObject(cell));
      }
    }

    updateEvents.add(MovementCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }
}