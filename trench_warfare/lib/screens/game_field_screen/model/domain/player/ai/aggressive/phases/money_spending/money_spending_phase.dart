part of money_spending_phase_library;

class MoneySpendingPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  MoneySpendingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required MapMetadataRead metadata,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata;

  @override
  Future<void> start() async {
    while (true) {
      final influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation()..calculate(data), _gameField);

      final List<_EstimationProcessor> processors = [
        _ProductionCenterEstimationProcessor(
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
            'ProductionCenter: ${averageWeights[0]}; SpecialStrike: ${averageWeights[1]}; '
            'TerrainModifier: ${averageWeights[2]}; UnitBooster: ${averageWeights[3]}; '
            'Units: ${averageWeights[4]}; Carriers: ${averageWeights[5]};',
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
        await selectedProcessor.process();
      } finally {
        playerCore.registerOnAnimationCompleted(null);
      }
    }
  }
}
