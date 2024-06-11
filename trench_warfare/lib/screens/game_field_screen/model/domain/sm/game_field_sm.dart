part of game_field_sm;

class GameFieldStateMachine {
  late final GameFieldRead _gameField;

  late final Nation _nation;

  late final MoneyStorage _money;

  late final MapMetadataRead _mapMetadata;

  late final GameFieldSettingsStorageRead _gameFieldSettingsStorage;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  final SimpleStream<GameFieldControlsState> _controlsState;

  final GameFieldModelCallback _modelCallback;

  State _currentState = Initial();

  GameFieldStateMachine(
    this._gameField,
    this._nation,
    this._money,
    this._mapMetadata,
    this._gameFieldSettingsStorage,
    this._updateGameObjectsEvent,
    this._controlsState,
    this._modelCallback,
  );

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
        OnStarTurn() => FromInitialOnOnStarTurnTransition(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _controlsState,
              _money.actual,
            ).process(),
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
          OnEndOfTurnButtonClick() => FromReadyForInputOnEndOfTurnButtonClick().process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          OnCellClick(cell: var cell) => FromWaitingForEndOfPathOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _money.actual,
              _controlsState,
            ).process(startPathCell, cell),
          OnEndOfTurnButtonClick() => FromWaitingForEndOfPathOnEndOfTurnButtonClick(
              _updateGameObjectsEvent,
              _gameField,
              _money.actual,
              _controlsState,
            ).process(startPathCell),
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
          OnEndOfTurnButtonClick() => FromPathIsShownOnEndOfTurnButtonClick(
              _updateGameObjectsEvent,
              _gameField,
              _money.actual,
              _controlsState,
            ).process(path),
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
        },
      TurnIsEnded() => switch (event) {
          OnStarTurn() => FromTurnIsEndedOnStartTurn(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _money,
              _controlsState,
              _gameFieldSettingsStorage,
            ).process(),
          _ => _currentState,
        }
    };

    _currentState = newState;

    if (_currentState is TurnIsEnded) {
      _modelCallback.onTurnCompleted();
    }
  }
}
