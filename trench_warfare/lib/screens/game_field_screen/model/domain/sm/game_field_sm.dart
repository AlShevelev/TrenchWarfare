part of game_field_sm;

class GameFieldStateMachine implements Disposable {
  late final GameFieldRead _gameField;

  late final Nation _nation;

  late final MoneyStorage _money;

  late final MapMetadataRead _mapMetadata;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  State _currentState = Initial();

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
          OnInit(
            gameField: var gameField,
            nation: var nation,
            money: var money,
            metadata: var metadata,
          ) =>
            _processInit(gameField, nation, money, metadata),
          _ => _currentState,
        },
      ReadyForInput() => switch (event) {
          OnCellClick(cell: var cell) => FromReadyForInputOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _money.actual,
              _controlsState,
            ).process(cell),
          OnLongCellClickStart(cell: var cell) => FromReadyForInputOnLongClickStart(
              _money.actual,
              _controlsState,
            ).process(cell),
          OnLongCellClickEnd() => FromReadyForInputOnLongClickEnd(
              _money.actual,
              _controlsState,
            ).process(),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromReadyForInputOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
              _controlsState,
            ).process(cellId, unitsId, isCarrier: isCarrier),
          OnCardsButtonClick() => FromReadyForInputOnCardsButtonClick(
              _money.actual,
              _controlsState,
              _gameField,
              _nation,
              _mapMetadata,
            ).process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          OnCellClick(cell: var cell) => FromWaitingForEndOfPathOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _money.actual,
              _controlsState,
            ).process(startPathCell, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromWaitingForEndOfPathOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
              _controlsState,
            ).process(startPathCell, cellId, unitsId, isCarrier: isCarrier),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          OnCellClick(cell: var cell) => FromPathIsShownOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _money.actual,
              _controlsState,
            ).process(path, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromPathIsShownOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
              _controlsState,
            ).process(path, cellId, unitsId, isCarrier: isCarrier),
          _ => _currentState,
        },
      MovingInProgress() => switch (event) {
          OnAnimationCompleted() => ReadyForInput(),
          _ => _currentState,
        },
      CardSelecting() => switch (event) {
          OnCancelled() => FromCardSelectingOnCardsSelectionCancelled(
              _money.actual,
              _controlsState,
            ).process(),
          OnCardSelected(card: var card) => FromCardSelectingOnCardsSelected(
              _updateGameObjectsEvent,
              _gameField,
              nationMoney: _money.actual,
              nation: _nation,
              controlsState: _controlsState,
              mapMetadata: _mapMetadata,
            ).process(card),
          _ => _currentState,
        },
      CardPlacing(
        card: var card,
        cellsImpossibleToBuild: var cellsImpossibleToBuild,
      ) =>
        switch (event) {
          OnCancelled() => FromCardPlacingOnCardPlacingCancelled(
              _updateGameObjectsEvent,
              _gameField,
              nationMoney: _money.actual,
              controlsState: _controlsState,
            ).process(cellsImpossibleToBuild),
          OnCellClick(cell: var cell) => FromCardPlacingOnCellClicked(
              _updateGameObjectsEvent,
              _gameField,
              nationMoney: _money,
              controlsState: _controlsState,
              myNation: _nation,
              mapMetadata: _mapMetadata,
            ).process(cellsImpossibleToBuild, cell, card),
          _ => _currentState,
        },
      CardPlacingSpecialStrikeInProgress(
        card: var card,
        newInactiveCells: var newInactiveCells,
        oldInactiveCells: var oldInactiveCells,
        productionCost: var productionCost,
        canPlaceNext: var canPlaceNext,
      ) =>
        switch (event) {
          OnAnimationCompleted() => FromCardPlacingSpecialStrikeInProgressOnAnimationCompleted(
              _updateGameObjectsEvent,
              _gameField,
              card: card,
              newInactiveCells: newInactiveCells,
              oldInactiveCells: oldInactiveCells,
              productionCost: productionCost,
              canPlaceNext: canPlaceNext,
              controlsState: _controlsState,
              nationMoney: _money,
            ).process(),
          _ => _currentState,
        }
    };

    _currentState = newState;
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
    _controlsState.close();
  }

  State _processInit(
      GameFieldRead gameField, Nation nation, MoneyStorage money, MapMetadataRead mapMetadata) {
    _gameField = gameField;
    _nation = nation;
    _money = money;
    _mapMetadata = mapMetadata;

    return FromInitialOnInitTransition(
      _updateGameObjectsEvent,
      _gameField,
      _controlsState,
      _money.actual,
    ).process();
  }
}
