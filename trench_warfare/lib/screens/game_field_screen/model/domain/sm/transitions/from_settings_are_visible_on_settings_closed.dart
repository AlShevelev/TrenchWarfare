part of game_field_sm;

class FromSettingsAreVisibleOnSettingsClosed {
  final GameFieldStateMachineContext _context;

  FromSettingsAreVisibleOnSettingsClosed(this._context);

  State process(SettingsResult result) {
    TransitionUtils(_context).closeUI();
    
    _context.animationTimeFacade.updateTime(result);

    return ReadyForInput();
  }
}