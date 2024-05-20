part of player;

class PlayerCore implements PlayerInput {
  final GameFieldRead _gameField;

  late final GameFieldStateMachine _stateMachine;

  final _gameFieldSettingsStorage = GameFieldSettingsStorage();

  bool _inputIsBlocked = true;
  @override
  bool get inputIsBlocked => _inputIsBlocked;

  PlayerCore(
    this._gameField,
    NationRecord playerNation,
    MapMetadataRead mapMetadata,
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    SingleStream<GameFieldControlsState> controlsState,
    GameFieldModelCallback modelCallback,
  ) {
    final money = MoneyStorage(_gameField, playerNation);

    _stateMachine = GameFieldStateMachine(
      _gameField,
      playerNation.code,
      money,
      mapMetadata,
      _gameFieldSettingsStorage,
      updateGameObjectsEvent,
      controlsState,
      modelCallback,
    );
  }

  void setInputBlock({required bool blocked}) => _inputIsBlocked = blocked;

  void init({required bool updateGameField}) {
    _stateMachine.process(OnInit(updateGameField: updateGameField));
  }

  @override
  void onClick(Vector2 position) => _processInput(() {
        final clickedCell = _gameField.findCellByPosition(position);
        _stateMachine.process(OnCellClick(clickedCell));
      });

  @override
  void onLongClickStart(Vector2 position) => _processInput(() {
        final clickedCell = _gameField.findCellByPosition(position);
        _stateMachine.process(OnLongCellClickStart(clickedCell));
      });

  @override
  void onLongClickEnd() => _processInput(() {
        _stateMachine.process(OnLongCellClickEnd());
      });

  @override
  void onAnimationComplete() => _processInput(() {
        _stateMachine.process(OnAnimationCompleted());
      });

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) => _processInput(() {
        _stateMachine.process(OnUnitsResorted(cellId, unitsId, isCarrier: isCarrier));
      });

  @override
  void onCardsButtonClick() => _processInput(() {
        _stateMachine.process(OnCardsButtonClick());
      });

  @override
  void onEndOfTurnButtonClick() => _processInput(() {
        _stateMachine.process(OnEndOfTurnButtonClick());
      });

  @override
  void onCardsSelectionCancelled() => _processInput(() {
        _stateMachine.process(OnCancelled());
      });

  @override
  void onCardSelected(GameFieldControlsCard? card) => _processInput(() {
        if (card == null) {
          _stateMachine.process(OnCancelled());
        } else {
          _stateMachine.process(OnCardSelected(card));
        }
      });

  @override
  void onCardsPlacingCancelled() => _processInput(() {
        _stateMachine.process(OnCancelled());
      });

  @override
  void onCameraUpdated(double zoom, Vector2 position) => _processInput(() {
        _gameFieldSettingsStorage.zoom = zoom;
        _gameFieldSettingsStorage.cameraPosition = position;
      });

  @override
  void onStartTurn() => _processInput(() {
    _stateMachine.process(OnStarTurn());
  });

  void _processInput(void Function() inputAction) {
    if (_inputIsBlocked) {
      return;
    }

    inputAction();
  }
}
