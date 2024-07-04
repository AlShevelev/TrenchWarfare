part of peaceful_player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  PeacefulPlayerAi(
    this._gameField,
    super.player,
    this._myNation,
    this._nationMoney,
    this._metadata,
  );

  @override
  void start() async {
    while (true) {
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

      final averageWeights = [
        processors[0].estimate(),
        processors[1].estimate(),
        processors[2].estimate(),
      ];

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      processors[generalActionIndex].process();
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
