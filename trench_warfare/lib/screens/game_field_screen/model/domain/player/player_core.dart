part of player;

class PlayerCore implements PlayerInput, PlayerGameObjectCallback {
  final GameFieldRead _gameField;

  late final GameFieldStateMachine _stateMachine;

  final _gameFieldSettingsStorage = GameFieldSettingsStorage();

  late final MoneyStorage _money;
  MoneyStorageRead get money => _money;

  PlayerCore(
    this._gameField,
    NationRecord playerNation,
    MapMetadataRead mapMetadata,
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    SimpleStream<GameFieldControlsState> controlsState,
    GameFieldModelCallback modelCallback, {
    required bool isAI,
  }) {
    _money = MoneyStorage(_gameField, playerNation);

    _stateMachine = GameFieldStateMachine(
      _gameField,
      playerNation.code,
      _money,
      mapMetadata,
      _gameFieldSettingsStorage,
      updateGameObjectsEvent,
      controlsState,
      modelCallback,
      isAI: isAI,
    );
  }

  @override
  void onClick(Vector2 position) {
    final clickedCell = _gameField.findCellByPosition(position);
    _stateMachine.process(OnCellClick(clickedCell));
  }

  @override
  void onLongClickStart(Vector2 position) {
    final clickedCell = _gameField.findCellByPosition(position);
    _stateMachine.process(OnLongCellClickStart(clickedCell));
  }

  @override
  void onLongClickEnd() => _stateMachine.process(OnLongCellClickEnd());

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) =>
      _stateMachine.process(OnUnitsResorted(cellId, unitsId, isCarrier: isCarrier));

  @override
  void onCardsButtonClick() => _stateMachine.process(OnCardsButtonClick());

  @override
  void onEndOfTurnButtonClick() => _stateMachine.process(OnEndOfTurnButtonClick());

  @override
  void onCardsSelectionCancelled() => _stateMachine.process(OnCancelled());

  @override
  void onCardSelected(GameFieldControlsCard? card) {
    if (card == null) {
      _stateMachine.process(OnCancelled());
    } else {
      log('AI_PEACEFUL 4. PlayerCore onCardSelected(${card.type})');
      _stateMachine.process(OnCardSelected(card));
    }
  }

  @override
  void onCardsPlacingCancelled() => _stateMachine.process(OnCancelled());

  @override
  void onCameraUpdated(double zoom, Vector2 position) {
    _gameFieldSettingsStorage.zoom = zoom;
    _gameFieldSettingsStorage.cameraPosition = position;
  }

  /// Starts a turn. Must not be called from the AI - it's called from the model
  @override
  void onStartTurn() => _stateMachine.process(OnStarTurn());

  @override
  void onAnimationComplete() => _stateMachine.process(OnAnimationCompleted());
}
