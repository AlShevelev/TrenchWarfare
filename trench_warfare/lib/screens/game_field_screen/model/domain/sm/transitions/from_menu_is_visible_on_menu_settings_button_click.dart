part of game_field_sm;

class FromMenuIsVisibleOnMenuSettingsButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuSettingsButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(SettingsControls());

    return SettingsAreVisible();
  }
}
