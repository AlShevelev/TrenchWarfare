part of aggressive_player_ai;

class AggressivePlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;
  Nation get myNation => _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final CarrierTroopTransfersStorage _transfersStorage;
  CarrierTroopTransfersStorageRead get transfersStorage => _transfersStorage;

  final SimpleStream<GameFieldControlsState> _aiProgressState;

  AggressivePlayerAi(
    GameFieldRead gameField,
    super.player,
    Nation myNation,
    MoneyStorageRead nationMoney,
    MapMetadataRead metadata,
    GameOverConditionsCalculator gameOverConditionsCalculator,
    Iterable<TroopTransferReadForSaving> initialTransfers,
    SimpleStream<GameFieldControlsState> aiProgressState,
  )   : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _transfersStorage = CarrierTroopTransfersStorage(
          gameField: gameField,
          myNation: myNation,
          metadata: metadata,
          initialTransfers: initialTransfers,
        ),
        _aiProgressState = aiProgressState;

  @override
  Future<void> start() async {
    _aiProgressState.update(AiTurnProgress(moneySpending: 0.0, unitMovement: 0.0));

    await Future.delayed(const Duration(milliseconds: 500));

    // If I lost - do nothing
    if (!_gameOverConditionsCalculator.isDefeated(_myNation)) {
      Logger.info('MoneySpendingPhase started', tag: 'AI_PLAYER_AGGRESSIVE');
      await MoneySpendingPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        metadata: _metadata,
        aiProgressState: _aiProgressState,
      ).start();
      Logger.info('MoneySpendingPhase completed', tag: 'AI_PLAYER_AGGRESSIVE');

      Logger.info('CarriersPhase started', tag: 'AI_PLAYER_AGGRESSIVE');
      await CarriersPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
        transfersStorage: _transfersStorage,
      ).start();
      Logger.info('CarriersPhase completed', tag: 'AI_PLAYER_AGGRESSIVE');

      final unitsExcludedToMove = _transfersStorage.allTransfers
          .map((t) => t.transportingUnits)
          .expand((i) => i)
          .map((u) => u)
          .toList(growable: false);

      Logger.info('UnitsMovingPhase started', tag: 'AI_PLAYER_AGGRESSIVE');
      await UnitsMovingPhase(
        player: player,
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
        aiProgressState: _aiProgressState,
        iterator: StableUnitsIterator(
          gameField: _gameField,
          myNation: _myNation,
          excludedUnits: unitsExcludedToMove,
        ),
      ).start();
      Logger.info('UnitsMovingPhase completed', tag: 'AI_PLAYER_AGGRESSIVE');
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }
}
