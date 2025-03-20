part of game_field_sm;

class GameFieldStateMachine {
  final GameFieldModelCallback _modelCallback;

  late final GameFieldStateMachineContext _context;

  final GamePauseWait? _gamePauseWait;

  State _currentState = Initial();

  GameFieldStateMachine(
    GameFieldRead gameField,
    Nation myNation,
    MoneyStorage money,
    MapMetadataRead mapMetadata,
    GameFieldSettingsStorageRead gameFieldSettingsStorage,
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    SimpleStream<GameFieldControlsState> controlsState,
    DayStorage dayStorage,
    GameOverConditionsCalculator gameOverConditionsCalculator,
    AnimationTimeFacade animationTimeFacade,
    GamePauseWait? gamePauseWait,
    MovementResultBridge? movementResultBridge,
    this._modelCallback, {
    required bool isAI,
    required bool isGameLoaded,
  }) : _gamePauseWait = gamePauseWait {
    _context = GameFieldStateMachineContext(
      gameField: gameField,
      myNation: myNation,
      money: money,
      mapMetadata: mapMetadata,
      gameFieldSettingsStorage: gameFieldSettingsStorage,
      updateGameObjectsEvent: updateGameObjectsEvent,
      controlsState: controlsState,
      isAI: isAI,
      dayStorage: dayStorage,
      gameOverConditionsCalculator: gameOverConditionsCalculator,
      modelCallback: _modelCallback,
      animationTimeFacade: animationTimeFacade,
      movementResultBridge: movementResultBridge,
    );

    if (isGameLoaded && isAI) {
      _currentState = dayStorage.day == 0 ? Initial() : TurnIsEnded();
    }
  }

  Future<void> process(Event event) async {
    Logger.info(
      'Start. nation: ${_context.myNation}; incomingEvent $event; currentState: $_currentState',
      tag: 'STATE_MACHINE',
    );

    await _gamePauseWait?.wait();

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
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isInCarrierMode: var isCarrier) =>
            FromReadyForInputOnResortUnit(_context).process(cellId, unitsId, isCarrier: isCarrier),
          OnCardsButtonClick() => FromReadyForInputOnCardsButtonClick(_context).process(),
          OnEndOfTurnButtonClick() => FromReadyForInputOnEndOfTurnButtonClick(_context).process(),
          OnMenuButtonClick() => FromReadyForInputOnMenuButtonClick(_context).process(),
          OnPhoneBackAction() => FromReadyForInputOnMenuButtonClick(_context).process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          OnCellClick(cell: var cell) =>
            FromWaitingForEndOfPathOnClick(_context).process(startPathCell, cell),
          OnEndOfTurnButtonClick() =>
            FromWaitingForEndOfPathOnEndOfTurnButtonClick(_context).process(startPathCell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isInCarrierMode: var isInCarrierMode) =>
            FromWaitingForEndOfPathOnResortUnit(_context)
                .process(startPathCell, cellId, unitsId, isInCarrierMode: isInCarrierMode),
          OnCardsButtonClick() =>
            FromWaitingForEndOfPathOnCardsButtonClick(_context, startPathCell).process(),
          OnMenuButtonClick() => FromWaitingForEndOfPathOnMenuButtonClick(_context, startPathCell).process(),
          OnPhoneBackAction() => FromWaitingForEndOfPathOnMenuButtonClick(_context, startPathCell).process(),
          OnDisbandUnitButtonClick() =>
            FromWaitingForEndOfPathOnDisbandUnitButtonClick(_context, startPathCell).process(),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          OnCellClick(cell: var cell) => FromPathIsShownOnClick(_context).process(path, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId, isInCarrierMode: var isInCarrierMode) =>
            FromPathIsShownOnResortUnit(_context).process(
              path,
              cellId,
              unitsId,
              isInCarrierMode: isInCarrierMode,
            ),
          OnEndOfTurnButtonClick() => FromPathIsShownOnEndOfTurnButtonClick(_context).process(path),
          OnMenuButtonClick() => FromPathIsShownOnMenuButtonClick(_context, path).process(),
          OnPhoneBackAction() => FromPathIsShownOnMenuButtonClick(_context, path).process(),
          OnDisbandUnitButtonClick() => FromPathIsShownOnDisbandUnitButtonClick(_context, path).process(),
          _ => _currentState,
        },
      MovingInProgress(
        isVictory: var isVictory,
        defeated: var defeated,
        cellsToUpdate: var cellsToUpdate,
      ) =>
        switch (event) {
          OnAnimationCompleted() => FromMovingInProgressOnAnimationCompleted(_context).process(
              isVictory,
              defeated,
              cellsToUpdate,
            ),
          _ => _currentState,
        },
      VictoryDefeatConfirmation(
        isVictory: var isVictory,
        cellsToUpdate: var cellsToUpdate,
      ) =>
        switch (event) {
          OnPopupDialogClosed() => FromVictoryDefeatConfirmationOnPopupDialogClosed(_context).process(
              isVictory,
              cellsToUpdate,
            ),
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
      CardPlacingInProgress(
        card: var card,
        newInactiveCells: var newInactiveCells,
        oldInactiveCells: var oldInactiveCells,
        productionCost: var productionCost,
        canPlaceNext: var canPlaceNext,
      ) =>
        switch (event) {
          OnAnimationCompleted() => FromCardPlacingInProgressOnAnimationCompleted(
              context: _context,
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
        },
      MenuIsVisible() => switch (event) {
          OnPhoneBackAction() => FromMenuIsVisibleOnPhoneBackAction(_context).process(),
          OnMenuQuitButtonClick() => FromMenuIsVisibleOnMenuQuitButtonClick(_context).process(),
          OnMenuSaveButtonClick() => FromMenuIsVisibleOnMenuSaveButtonClick(_context).process(),
          OnMenuObjectivesButtonClick() => FromMenuIsVisibleOnMenuObjectivesButtonClick(_context).process(),
          OnMenuSettingsButtonClick() => FromMenuIsVisibleOnMenuSettingsButtonClick(_context).process(),
          _ => _currentState,
        },
      SaveSlotSelection() => switch (event) {
          OnCancelled() => FromSaveSlotSelectionOnCancelled(_context).process(),
          OnSaveSlotSelected(slot: var slot) =>
            FromSaveSlotSelectionOnSaveSlotSelected(_context, slot).process(),
          _ => _currentState,
        },
      ObjectivesAreVisible() => switch (event) {
          OnPopupDialogClosed() => FromObjectivesAreVisibleOnPopupDialogClosed(_context).process(),
          OnPhoneBackAction() => FromObjectivesAreVisibleOnPopupDialogClosed(_context).process(),
          _ => _currentState,
        },
      SettingsAreVisible() => switch (event) {
          OnSettingsClosed(result: var result) =>
            FromSettingsAreVisibleOnSettingsClosed(_context).process(result),
          _ => _currentState,
        },
      TurnEndConfirmationNeeded(cellToMoveCamera: var cellToMoveCamera) => switch (event) {
          OnUserConfirmed() => FromTurnEndConfirmationNeededOnUserConfirmed(_context).process(),
          OnUserDeclined() => FromTurnEndConfirmationNeededOnUserDeclined(_context).process(cellToMoveCamera),
          _ => _currentState,
        },
      DisbandUnitConfirmationNeeded(
        cellWithUnitToDisband: final cellWithUnitToDisband,
        pathOfUnit: final pathOfUnit,
        priorUiState: final priorUiState,
      ) =>
        switch (event) {
          OnUserConfirmed() => FromDisbandUnitConfirmationNeededOnUserConfirmed(
              context: _context,
              cellWithUnitToDisband: cellWithUnitToDisband,
              pathOfUnit: pathOfUnit,
            ).process(),
          OnUserDeclined() => FromDisbandUnitConfirmationNeededOnUserDeclined(
              context: _context,
              cellWithUnitToDisband: cellWithUnitToDisband,
              pathOfUnit: pathOfUnit,
              priorUiState: priorUiState,
            ).process(),
          _ => _currentState,
        },
    };

    _currentState = newState;

    Logger.info(
      'Finish. nation: ${_context.myNation}; newState: $_currentState',
      tag: 'STATE_MACHINE',
    );

    if (_currentState is TurnIsEnded) {
      _modelCallback.onTurnCompleted();
    } else if (_currentState is GameIsOver) {
      _modelCallback.onGameIsOver();
    }
  }
}
