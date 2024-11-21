part of game_field_sm;

class FromInitialOnStarTurnTransition {
  final GameFieldStateMachineContext _context;

  FromInitialOnStarTurnTransition(this._context);

  State process() {
    _context.dayStorage.increaseDay();

    _context.controlsState.update(StartTurnControls(
      nation: _context.nation,
      day: _context.dayStorage.day,
    ));

    return StartTurnInitialConfirmation();
  }
}
