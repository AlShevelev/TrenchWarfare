part of units_moving_phase_library;

class UnitsMovingPhase implements TurnPhase {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final PlayerActions _actions;

  final MapMetadataRead _metadata;

  final StableUnitsIterator _iterator;

  UnitsMovingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required StableUnitsIterator iterator,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _iterator = iterator,
        _actions = PlayerActions(player: player) {
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
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _iterator = iterator,
        _actions = actions;

  @override
  Future<void> start() async {
    while (_iterator.moveNext()) {
      final unit = _iterator.current.unit;

      GameFieldCellRead? cellWithUnit = _iterator.current.cell;

      late InfluenceMapRepresentationRead influences;

      // the unit is not dead and can move
      while (cellWithUnit != null && unit.state != UnitState.disabled) {
        influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
            (data) => InfluenceMapRepresentation()..calculate(data), _gameField);

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

        final weightIndex =
            RandomGen.randomWeight(indexedWeights.map((e) => e.item2).toList(growable: false));

        // Skip this unit
        if (weightIndex == null) {
          break;
        }

        final selectedEstimator = estimators[indexedWeights[weightIndex].item1];
        await selectedEstimator.processAction();

        // check the unit is dead or not (cellWithUnit == null - is dead)
        cellWithUnit = _gameField.getCellWithUnit(unit, _myNation);
        if (cellWithUnit == null) {
          break;
        }
      }
    }
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
}
