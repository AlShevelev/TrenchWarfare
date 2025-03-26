part of peaceful_player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final SimpleStream<GameFieldControlsState> _aiProgressState;

  PeacefulPlayerAi(
    GameFieldRead gameField,
    super.player,
    Nation myNation,
    MoneyStorageRead nationMoney,
    MapMetadataRead metadata,
    GameOverConditionsCalculator gameOverConditionsCalculator,
    SimpleStream<GameFieldControlsState> aiProgressState,
  )   : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _aiProgressState = aiProgressState;

  @override
  Future<void> start() async {
    _aiProgressState.update(AiTurnProgress(moneySpending: 0.0, unitMovement: 0.0));

    await Future.delayed(const Duration(milliseconds: 500));

    final startMoney = _nationMoney.totalSum.currency.toDouble();

    // If I lost - do nothing
    while (!_gameOverConditionsCalculator.isDefeated(_myNation)) {
      final influences = await compute<InfluenceMapComputeData, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation(
                myNation: data.myNation,
                metadata: data.metadata,
              )..calculateFull(data.gameField),
          InfluenceMapComputeData(
            myNation: _myNation,
            metadata: _metadata,
            gameField: _gameField,
          ));

      final List<EstimationProcessor> processors = [
        ProductionCenterEstimationProcessor(
          player: player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        MineFieldEstimationProcessor(
          player: player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
        UnitsEstimationProcessor(
          player: player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
        ),
      ];

      final averageWeights = processors.map((p) => p.estimate()).toList(growable: false);

      Logger.info(
        'calculated weights are: ProductionCenter: ${averageWeights[0]}; '
        'MineField: ${averageWeights[1]}; Units: ${averageWeights[2]}',
        tag: 'AI_PLAYER_PEACEFUL',
      );

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

      Logger.info('selected index is: $generalActionIndex', tag: 'AI_PLAYER_PEACEFUL');

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      final selectedProcessor = processors[generalActionIndex];

      // It's a dirty, but necessary hack
      final playerCore = player as PlayerCore;
      playerCore.registerOnAnimationCompleted(() {
        selectedProcessor.onAnimationCompleted();
      });

      try {
        await selectedProcessor.process();
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

    await Future.delayed(const Duration(seconds: 1));

    _aiProgressState.update(Invisible());

    player.onEndOfTurnButtonClick();
  }
}
