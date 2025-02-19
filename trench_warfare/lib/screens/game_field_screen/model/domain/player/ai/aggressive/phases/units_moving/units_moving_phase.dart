part of units_moving_phase_library;

class UnitsMovingPhase implements TurnPhase {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final PlayerActions _actions;

  final MapMetadataRead _metadata;

  final StableUnitsIterator _iterator;

  final SimpleStream<GameFieldControlsState>? _aiProgressState;

  UnitsMovingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required StableUnitsIterator iterator,
    required MapMetadataRead metadata,
    required SimpleStream<GameFieldControlsState>? aiProgressState,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _iterator = iterator,
        _actions = PlayerActions(player: player),
        _aiProgressState = aiProgressState {
    // It's a dirty, but necessary hack
    final playerCore = player as PlayerCore;
    playerCore.registerOnAnimationCompleted(() {
      _actions.onAnimationCompleted();
    });
  }

  UnitsMovingPhase.withActions({
    required GameFieldRead gameField,
    required Nation myNation,
    required StableUnitsIterator iterator,
    required MapMetadataRead metadata,
    required PlayerActions actions,
    required SimpleStream<GameFieldControlsState>? aiProgressState,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _iterator = iterator,
        _actions = actions,
        _aiProgressState = aiProgressState;

  @override
  Future<void> start() async {
    final totalItems = _iterator.getTotalItems().toDouble();
    var counter = 0;
    _updateControlStateProgress(0.0);

    while (_iterator.moveNext()) {
      final unit = _iterator.current.unit;

      GameFieldCellRead? cellWithUnit = _iterator.current.cell;

      late InfluenceMapRepresentationRead influences;

      // the unit is not dead and can move
      while (cellWithUnit != null && unit.state != UnitState.disabled) {
        Logger.info('processing unit: $unit on cell: $cellWithUnit', tag: 'UNITS_MOVING');

        influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
            (data) => InfluenceMapRepresentation()..calculate(data), _gameField);

        Logger.info('influence map is recalculated', tag: 'UNITS_MOVING');

        final estimators = _createEstimators(
          influences: influences,
          unit: unit,
          cell: cellWithUnit,
        );

        Logger.info(
          'estimators: Attack[0]; CarrierInterception[1]; DoNothing[2]; MoveToEnemyPc[3]; '
          'MoveToMyPc[4]; Resort[5]',
          tag: 'UNITS_MOVING',
        );

        final List<Tuple2<int, double>> indexedWeights = estimators
            .mapIndexed((i, e) => Tuple2<int, double>(i, e.estimate()))
            .where((i) => i.item2 >= 1.0) // Skip the failed estimations
            .map((i) => Tuple2<int, double>(i.item1, InGameMath.log10(i.item2)))
            .where((i) => i.item2 != 0) // Skip and estimation errors
            .toList(growable: false);

        Logger.info(
          'estimation result: ${indexedWeights.map((e) => '[${e.item1} : ${e.item2}]').join(' | ')};',
          tag: 'UNITS_MOVING',
        );

        final weightIndex =
            RandomGen.randomWeight(indexedWeights.map((e) => e.item2).toList(growable: false));

        // Skip this unit
        if (weightIndex == null) {
          break;
        }

        Logger.info('selected estimator index is: ${indexedWeights[weightIndex].item1}',
            tag: 'MONEY_SPENDING');

        final selectedEstimator = estimators[indexedWeights[weightIndex].item1];
        await selectedEstimator.processAction();

        // check the unit is dead or not (cellWithUnit == null - is dead)
        cellWithUnit = _gameField.getCellWithUnit(unit, _myNation);
        if (cellWithUnit == null) {
          break;
        }
      }

      _updateControlStateProgress(++counter / totalItems);
    }
    _updateControlStateProgress(1.0);
  }

  List<_UnitEstimationProcessorBase> _createEstimators({
    required InfluenceMapRepresentationRead influences,
    required Unit unit,
    required GameFieldCellRead cell,
  }) =>
      [
        _AttackEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        _CarrierInterceptionEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        _DoNothingEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        _MoveToEnemyPcEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        _MoveToMyPcEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
        _ResortEstimationProcessor(
          actions: _actions,
          influences: influences,
          unit: unit,
          cell: cell,
          myNation: _myNation,
          metadata: _metadata,
          gameField: _gameField,
        ),
      ];

  void _updateControlStateProgress(double value) => _aiProgressState?.current
      ?.let((c) => _aiProgressState?.update((c as AiTurnProgress).copy(unitMovement: value)));
}
