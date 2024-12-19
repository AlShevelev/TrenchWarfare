part of game_field_sm;

class FromSettingsAreVisibleOnSettingsClosed {
  final GameFieldStateMachineContext _context;

  FromSettingsAreVisibleOnSettingsClosed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}