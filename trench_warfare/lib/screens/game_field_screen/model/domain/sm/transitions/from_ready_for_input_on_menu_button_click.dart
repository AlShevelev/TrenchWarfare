part of game_field_sm;

class FromReadyForInputOnMenuButtonClick {
  final GameFieldStateMachineContext _context;

  FromReadyForInputOnMenuButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(MenuControls(
      nation: _context.myNation,
      day: _context.dayStorage.day,
    ));

    return MenuIsVisible();
  }
}
