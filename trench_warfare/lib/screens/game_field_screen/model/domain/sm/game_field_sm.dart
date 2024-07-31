part of game_field_sm;

class GameFieldStateMachine {
  final GameFieldModelCallback _modelCallback;

  late final GameFieldStateMachineContext _context;

  State _currentState = Initial();

  GameFieldStateMachine(
    GameFieldRead gameField,
    Nation nation,
    MoneyStorage money,
    MapMetadataRead mapMetadata,
    GameFieldSettingsStorageRead gameFieldSettingsStorage,
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    SimpleStream<GameFieldControlsState> controlsState,
    DayStorage dayStorage,
    GameOverConditionsCalculator gameOverConditionsCalculator,
    this._modelCallback, {
    required bool isAI,
  }) {
    _context = GameFieldStateMachineContext(
      gameField: gameField,
      nation: nation,
      money: money,
      mapMetadata: mapMetadata,
      gameFieldSettingsStorage: gameFieldSettingsStorage,
      updateGameObjectsEvent: updateGameObjectsEvent,
      controlsState: controlsState,
      isAI: isAI,
      dayStorage: dayStorage,
      gameOverConditionsCalculator: gameOverConditionsCalculator,
    );
  }

  void process(Event event) {
    log('SM start. Nation is: ${_context.nation}; Event is: $event; State is: $_currentState');

    final newState = switch (_currentState) {
      Initial() => switch (event) {
          OnStarTurn() => FromInitialOnStarTurnTransition(_context).process(),
          _ => _currentState,
        },
      StartTurnInitialConfirmation() => switch (event) {
          OnPopupDialogClosed() => FromStartTurnInitialConfirmationOnStarTurnConfirmed(_context).process(),
          _ => _currentState,
        },
      ReadyForInput() => switch (event) {
          OnCellClick(cell: var cell) => FromReadyForInputOnClick(_context).process(cell),
          OnLongCellClickStart(cell: var cell) => FromReadyForInputOnLongClickStart(_context).process(cell),
          OnLongCellClickEnd() => FromReadyForInputOnLongClickEnd(_context).process(),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromReadyForInputOnResortUnit(_context).process(cellId, unitsId, isCarrier: isCarrier),
          OnCardsButtonClick() => FromReadyForInputOnCardsButtonClick(_context).process(),
          OnEndOfTurnButtonClick() => FromReadyForInputOnEndOfTurnButtonClick().process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          OnCellClick(cell: var cell) =>
            FromWaitingForEndOfPathOnClick(_context).process(startPathCell, cell),
          OnEndOfTurnButtonClick() =>
            FromWaitingForEndOfPathOnEndOfTurnButtonClick(_context).process(startPathCell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromWaitingForEndOfPathOnResortUnit(_context)
                .process(startPathCell, cellId, unitsId, isCarrier: isCarrier),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          OnCellClick(cell: var cell) => FromPathIsShownOnClick(_context).process(path, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isCarrier: var isCarrier) =>
            FromPathIsShownOnResortUnit(_context).process(path, cellId, unitsId, isCarrier: isCarrier),
          OnEndOfTurnButtonClick() => FromPathIsShownOnEndOfTurnButtonClick(_context).process(path),
          _ => _currentState,
        },
      MovingInProgress(isVictory: var isVictory, defeated: var defeated) => switch (event) {
          OnAnimationCompleted() => FromMovingInProgressOnAnimationCompleted(_context).process(
              isVictory,
              defeated,
            ),
          _ => _currentState,
        },
      VictoryDefeatConfirmation(isVictory: var isVictory) => switch (event) {
          OnPopupDialogClosed() =>
            FromVictoryDefeatConfirmationOnPopupDialogClosed(_context).process(isVictory),
          _ => _currentState,
        },
      CardSelecting() => switch (event) {
          OnCancelled() => FromCardSelectingOnCardsSelectionCancelled(_context).process(),
          OnCardSelected(card: var card) => FromCardSelectingOnCardsSelected(_context).process(card),
          _ => _currentState,
        },
      CardPlacing(
        card: var card,
        cellsImpossibleToBuild: var cellsImpossibleToBuild,
      ) =>
        switch (event) {
          OnCancelled() => FromCardPlacingOnCardPlacingCancelled(_context).process(cellsImpossibleToBuild),
          OnCellClick(cell: var cell) =>
            FromCardPlacingOnCellClicked(_context).process(cellsImpossibleToBuild, cell, card),
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
              _context,
              card: card,
              newInactiveCells: newInactiveCells,
              oldInactiveCells: oldInactiveCells,
              productionCost: productionCost,
              canPlaceNext: canPlaceNext,
            ).process(),
          _ => _currentState,
        },
      TurnIsEnded() => switch (event) {
          OnStarTurn() => FromTurnIsEndedOnStartTurn(_context).process(),
          _ => _currentState,
        },
      StartTurnConfirmation() => switch (event) {
          OnPopupDialogClosed() => FromStartTurnConfirmationOnStarTurnConfirmed(_context).process(),
          _ => _currentState,
        },
      GameIsOver() => switch (event) {
        _ => _currentState,
      }
    };

    _currentState = newState;

    log('SM finish. Nation is: ${_context.nation}; New state is: $newState');

    if (_currentState is TurnIsEnded) {
      _modelCallback.onTurnCompleted();
    } else if (_currentState is GameIsOver) {
      _modelCallback.onGameIsOver();
    }
  }
}
