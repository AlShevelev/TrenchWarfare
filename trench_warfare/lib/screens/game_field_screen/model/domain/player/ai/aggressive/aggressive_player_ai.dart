part of aggressive_player_ai;

class AggressivePlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final CarrierTroopTransfersStorage _transfersStorage;

  AggressivePlayerAi(
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
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _transfersStorage = CarrierTroopTransfersStorage(
          gameField: gameField,
          myNation: myNation,
          metadata: metadata
        );

  @override
  void start() async {
    // If I lost - do nothing
    if (!_gameOverConditionsCalculator.isDefeated(_myNation)) {
      await MoneySpendingPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        metadata: _metadata,
      ).start();

      await UnitsMovingPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
        iterator: StableUnitsIterator(gameField: _gameField, myNation: _myNation),
      ).start();

      await CarriersPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
        transfersStorage: _transfersStorage,
      ).start();
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
