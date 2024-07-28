part of game_field_sm;

class FromInitialOnStarTurnTransition extends GameObjectTransitionBase {
  FromInitialOnStarTurnTransition(super.context);

  State process() {
    _context.dayStorage.increaseDay();

    _context.controlsState.update(StartTurnControls(
      nation: _context.nation,
      day: _context.dayStorage.day,
    ));

    return StartTurnInitialConfirmation();
  }
}
