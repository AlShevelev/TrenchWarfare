part of player;

class PlayerCore extends PlayerInputProxy implements PlayerMoney {
  final GameFieldRead _gameField;

  late final GameFieldStateMachine _stateMachine;

  final GameFieldSettingsStorage _gameFieldSettingsStorage;

  late final Nation _myNation;

  @override
  Nation get nation => _myNation;

  late final MoneyStorage _money;

  @override
  MoneyStorageRead get money => _money;

  void Function()? _onAnimationCompleted;

  PlayerCore(
    this._gameField,
    this._gameFieldSettingsStorage,
    MapMetadataRead mapMetadata,
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    SimpleStream<GameFieldControlsState> controlsState,
    GameFieldModelCallback modelCallback,
    DayStorage dayStorage,
    GameOverConditionsCalculator gameOverConditionsCalculator,
    MoneyStorage money,
    AnimationTimeFacade animationTimeFacade, {
    required GamePauseWait? gamePauseWait,
    required MovementResultBridge? movementResultBridge,
    required bool isAI,
    required bool isGameLoaded,
    required Nation myNation,
    required Nation humanNation,
  }) {
    _money = money;

    _myNation = myNation;

    _stateMachine = GameFieldStateMachine(
      _gameField,
      myNation: _myNation,
      humanNation: humanNation,
      _money,
      mapMetadata,
      _gameFieldSettingsStorage,
      updateGameObjectsEvent,
      controlsState,
      dayStorage,
      gameOverConditionsCalculator,
      animationTimeFacade,
      gamePauseWait,
      movementResultBridge,
      modelCallback,
      isAI: isAI,
      isGameLoaded: isGameLoaded,
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
      _stateMachine.process(OnUnitsResorted(cellId, unitsId, isInCarrierMode: isCarrier));

  @override
  void onCardsButtonClick() => _stateMachine.process(OnCardsButtonClick());

  @override
  void onEndOfTurnButtonClick() => _stateMachine.process(OnEndOfTurnButtonClick());

  @override
  void onCancelled() => _stateMachine.process(OnCancelled());

  @override
  void onCardSelected(GameFieldControlsCard? card) {
    if (card == null) {
      _stateMachine.process(OnCancelled());
    } else {
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
  void onAnimationComplete() {
    _stateMachine.process(OnAnimationCompleted());

    final onAnimationCompleted = _onAnimationCompleted;
    if (onAnimationCompleted != null) {
      onAnimationCompleted();
    }
  }

  void registerOnAnimationCompleted(void Function()? onAnimationCompleted) {
    _onAnimationCompleted = onAnimationCompleted;
  }

  @override
  void onPopupDialogClosed() => _stateMachine.process(OnPopupDialogClosed());

  @override
  void onMenuButtonClick() => _stateMachine.process(OnMenuButtonClick());

  @override
  void onPhoneBackAction() => _stateMachine.process(OnPhoneBackAction());

  @override
  void onMenuQuitButtonClick() => _stateMachine.process(OnMenuQuitButtonClick());

  @override
  void onMenuObjectivesButtonClick() => _stateMachine.process(OnMenuObjectivesButtonClick());

  @override
  void onMenuSaveButtonClick() => _stateMachine.process(OnMenuSaveButtonClick());

  @override
  void onMenuSettingsButtonClick() => _stateMachine.process(OnMenuSettingsButtonClick());

  @override
  void onSaveSlotSelected(GameSlot slot) => _stateMachine.process(OnSaveSlotSelected(slot: slot));

  @override
  void onSettingsClosed(SettingsResult result) => _stateMachine.process(OnSettingsClosed(result: result));

  @override
  void onUserConfirmed() => _stateMachine.process(OnUserConfirmed());

  @override
  void onUserDeclined() => _stateMachine.process(OnUserDeclined());

  @override
  void onDisbandUnitButtonClick() => _stateMachine.process(OnDisbandUnitButtonClick());
}
