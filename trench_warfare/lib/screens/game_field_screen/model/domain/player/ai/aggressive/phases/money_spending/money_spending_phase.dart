part of money_spending_phase_library;

class MoneySpendingPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final SimpleStream<GameFieldControlsState> _aiProgressState;

  MoneySpendingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required MapMetadataRead metadata,
    required SimpleStream<GameFieldControlsState> aiProgressState,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _aiProgressState = aiProgressState;

  @override
  Future<void> start() async {
    final startMoney = _nationMoney.totalSum.currency.toDouble();
    _aiProgressState.update(AiTurnProgress(moneySpending: 0.0, unitMovement: 0.0));

    while (true) {
      Logger.info('loop started', tag: 'MONEY_SPENDING');
      final influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation()..calculate(data), _gameField);
      Logger.info('influences map is calculated', tag: 'MONEY_SPENDING');

      final List<_EstimationProcessor> processors = [
        _ProductionCenterEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _AirFieldEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _SpecialStrikeEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _TerrainModifierEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _UnitBoosterEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _UnitsEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        _CarriersEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
      ];

      final averageWeights = processors.map((p) => p.estimate()).toList(growable: false);

      Logger.info(
        'calculated weights are: '
        'ProductionCenter: ${averageWeights[0]}; _AirField: ${averageWeights[1]}; '
        'SpecialStrike: ${averageWeights[2]}; TerrainModifier: ${averageWeights[3]}; '
        'UnitBooster: ${averageWeights[4]}; Units: ${averageWeights[5]}; '
        'Carriers: ${averageWeights[6]};',
        tag: 'MONEY_SPENDING',
      );

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

      Logger.info('selected index is: $generalActionIndex', tag: 'MONEY_SPENDING');

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      final selectedProcessor = processors[generalActionIndex];

      // It's a dirty, but necessary hack
      final playerCore = _player as PlayerCore;
      playerCore.registerOnAnimationCompleted(() {
        selectedProcessor.onAnimationCompleted();
      });

      try {
        Logger.info('selectedProcessor.process() started', tag: 'MONEY_SPENDING');
        await selectedProcessor.process();
        Logger.info('selectedProcessor.process() completed', tag: 'MONEY_SPENDING');
      } catch (e, s) {
        Logger.error(e.toString(), stackTrace: s);
      } finally {
        playerCore.registerOnAnimationCompleted(null);
      }

      _aiProgressState.update(
        AiTurnProgress(
          moneySpending: 1.0 - _nationMoney.totalSum.currency / startMoney,
          unitMovement: 0.0,
        ),
      );
    }

    _aiProgressState.update(AiTurnProgress(moneySpending: 1.0, unitMovement: 0.0));
  }
}
