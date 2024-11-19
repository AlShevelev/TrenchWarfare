part of game_field_sm;

class FromMenuIsVisibleOnPhoneBackAction {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnPhoneBackAction(GameFieldStateMachineContext context) : _context = context;

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}
