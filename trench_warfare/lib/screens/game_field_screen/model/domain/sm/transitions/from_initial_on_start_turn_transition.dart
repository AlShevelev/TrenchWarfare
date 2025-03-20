part of game_field_sm;

class FromInitialOnStarTurnTransition {
  final GameFieldStateMachineContext _context;

  FromInitialOnStarTurnTransition(this._context);

  State process() {
    if (_context.dayStorage.day == 0) {
      _context.dayStorage.increaseDay();
    }

    _context.controlsState.update(StartTurnControls(
      nation: _context.myNation,
      day: _context.dayStorage.day,
    ));

    if (!_context.isAI) {
      _context.modelCallback.saveGame(GameSlot.autoSave);
    }

    return StartTurnInitialConfirmation();
  }
}
