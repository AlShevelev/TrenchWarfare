part of aggressive_player_ai;

class UnitsMovingPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final PlayerActions _actions;

  final MapMetadataRead _metadata;

  UnitsMovingPhase(
      {required PlayerInput player,
      required GameFieldRead gameField,
      required Nation myNation,
      required MapMetadataRead metadata})
      : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _actions = PlayerActions(player: player) {
    // It's a dirty, but necessary hack
    final playerCore = _player as PlayerCore;
    playerCore.registerOnAnimationCompleted(() => _actions.onAnimationCompleted);
  }

  @override
  Future<void> start() async {
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

        if (cellWithUnit != iterator.current.cell) {
          needRecalculateInfluences = true;
        }
      }
    }
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
        MoveToEnemyPcEstimationProcessor(
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
