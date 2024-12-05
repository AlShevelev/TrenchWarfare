part of game_field_sm;

class FromTurnIsEndedOnStartTurn {
  final GameFieldStateMachineContext _context;

  FromTurnIsEndedOnStartTurn(this._context);

  State process() {
    _context.dayStorage.increaseDay();

    _context.controlsState.update(StartTurnControls(
      nation: _context.nation,
      day: _context.dayStorage.day,
    ));

    if (!_context.isAI) {
      _context.modelCallback.saveGame(GameSlot.autoSave);
    }

    return StartTurnConfirmation();
  }
}
