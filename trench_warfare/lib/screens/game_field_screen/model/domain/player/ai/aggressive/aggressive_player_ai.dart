part of aggressive_player_ai;

class AggressivePlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  AggressivePlayerAi(
    this._gameField,
    super.player,
    this._myNation,
    this._nationMoney,
    this._metadata,
  );

  @override
  void start() async {
    final iLost = LoseCalculator.didILose(_gameField, myNation: _myNation);

    // If I lost - do nothing
    if (!iLost) {
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
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
