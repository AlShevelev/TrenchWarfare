part of peaceful_player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  PeacefulPlayerAi(
    GameFieldRead gameField,
    super.player,
    Nation myNation,
    MoneyStorageRead nationMoney,
    MapMetadataRead metadata,
    GameOverConditionsCalculator gameOverConditionsCalculator,
  )   : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _gameOverConditionsCalculator = gameOverConditionsCalculator;

  @override
  Future<void> start() async {
    // If I lost - do nothing
    while (!_gameOverConditionsCalculator.isDefeated(_myNation)) {
      final influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation()..calculate(data), _gameField);

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

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

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
      } finally {
        playerCore.registerOnAnimationCompleted(null);
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
