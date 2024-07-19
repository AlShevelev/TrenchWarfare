part of aggressive_player_ai;

class UnitsMovingPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MovementRegistry _movementRegistry;

  final PlayerActions _actions;

  UnitsMovingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _movementRegistry = MovementRegistryImpl(),
        _actions = PlayerActions(player: player) {
    // It's a dirty, but necessary hack
    final playerCore = _player as PlayerCore;
    playerCore.registerOnAnimationCompleted(() => _actions.onAnimationCompleted);
  }

  @override
  Future<void> start() async {
    _removeDeadFromMovementRegistry();

    final iterator = StableUnitsIterator(gameField: _gameField, myNation: _myNation);
    while (iterator.moveNext()) {
      final unit = iterator.current.unit;
      GameFieldCellRead? cellWithUnit = iterator.current.cell;

      // the unit is not dead and can move
      while (cellWithUnit != null && unit.state != UnitState.disabled) {
        final goal = _movementRegistry.getGoal(unit.id);

        if (goal != null) {
          if (goal.isReachable()) {
            final cellTo = goal.getGoalCell();
            await _actions.move(unit, from: cellWithUnit, to: cellTo);

            // check where the unit is located in a moment
            cellWithUnit = _gameField.getCellWithUnit(unit, _myNation);

            // the unit is dead or the goal is reached
            if (cellWithUnit == null || cellWithUnit == cellTo) {
              _movementRegistry.removeGoal(unit.id);
            }
          } else {
            _movementRegistry.removeGoal(unit.id);
          }
        } else {
          final estimators = _createEstimators();

          final List<Tuple2<int, double>> indexedWeights = estimators
              .mapIndexed((i, e) => Tuple2<int, double>(i, e.estimate()))
              .where((i) => i.item2 != 0)
              .map((i) => Tuple2<int, double>(i.item1, log10(i.item2)))
              .toList(growable: false);

          final weightIndex = RandomGen.randomWeight(indexedWeights.map((e) => e.item2));

          // Skip this unit
          if (weightIndex == null) {
            break;
          }

          final  selectedEstimator = estimators[indexedWeights[weightIndex].item1];
          final targetCell = await selectedEstimator.processAction();

          cellWithUnit = _gameField.getCellWithUnit(unit, _myNation);

          if (cellWithUnit != null && cellWithUnit != targetCell) {
            _movementRegistry.addGoal(unit.id, MoveToTheCellGoal(cellToMove: targetCell));
          }
        }
      }
    }
  }

  void _removeDeadFromMovementRegistry() {
    final iterator = StableUnitsIterator(gameField: _gameField, myNation: _myNation);

    final usedUnitIds = <String>[];
    while (iterator.moveNext()) {
      final unitId = iterator.current.unit.id;
      if (_movementRegistry.getGoal(unitId) != null) {
        usedUnitIds.add(unitId);
      }
    }

    _movementRegistry.exclude(usedUnitIds);
  }

  List<UnitEstimationProcessorBase> _createEstimators() => [
        AttackEstimationProcessor(actions: _actions),
        DoNothingEstimationProcessor(actions: _actions),
        MoveToAttackEstimationProcessor(actions: _actions),
        MoveToEnemyPcEstimationProcessor(actions: _actions),
        MoveToEnemyUnitOnUnreachableCellEstimationProcessor(actions: _actions),
        MoveToMineFieldEstimationProcessor(actions: _actions),
        MoveToMyArmyEstimationProcessor(actions: _actions),
        MoveToMyPcEstimationProcessor(actions: _actions),
        MoveToTerrainModifierEstimationProcessor(actions: _actions),
        ResortEstimationProcessor(actions: _actions),
      ];
}
