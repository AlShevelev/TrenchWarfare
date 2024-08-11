part of aggressive_player_ai;

class AggressivePlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final ActiveCarrierTroopTransfers _activeCarrierTroopTransfers;

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
        _activeCarrierTroopTransfers = ActiveCarrierTroopTransfers(
          gameField: gameField,
          myNation: myNation,
        );

  @override
  void start() async {
    // If I lost - do nothing
    if (!_gameOverConditionsCalculator.isDefeated(_myNation)) {
      await MoneySpendingPhase(
        player,
        _gameField,
        _myNation,
        _nationMoney,
        _metadata,
      ).start();

      await UnitsMovingPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
      ).start();

      await CarriersPhase(
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
        activeCarrierTroopTransfers: _activeCarrierTroopTransfers,
      ).start();
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
