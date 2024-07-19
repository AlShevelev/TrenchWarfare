part of aggressive_player_ai;

class UnitsMovingPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MovementRegistry _movementRegistry;

  final PlayerActions _actions;

  final MapMetadataRead _metadata;

  UnitsMovingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
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

      bool needRecalculateInfluences = true;
      late InfluenceMapRepresentationRead influences;

      // the unit is not dead and can move
      while (cellWithUnit != null && unit.state != UnitState.disabled) {
        if (needRecalculateInfluences) {
          influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
              (data) => InfluenceMapRepresentation()..calculate(data), _gameField);
          needRecalculateInfluences = false;
        }

        final goal = _movementRegistry.getGoal(unit.id);

        if (goal != null) {
          if (goal.isReachable()) {
            final cellTo = goal.getGoalCell();
            await _actions.move(unit, from: cellWithUnit, to: cellTo);
            needRecalculateInfluences = true;

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
          final estimators = _createEstimators(
            influences: influences,
            unit: unit,
            cell: cellWithUnit,
          );

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

          final selectedEstimator = estimators[indexedWeights[weightIndex].item1];
          final targetCell = await selectedEstimator.processAction();
          needRecalculateInfluences = true;

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

  List<UnitEstimationProcessorBase> _createEstimators({
    required InfluenceMapRepresentationRead influences,
    required Unit unit,
    required GameFieldCellRead cell,
  }) =>
      [
        AttackEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        DoNothingEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToAttackEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToEnemyPcEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToEnemyUnitOnUnreachableCellEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToMineFieldEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToMyArmyEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToMyPcEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        MoveToTerrainModifierEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        ResortEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
      ];
}
