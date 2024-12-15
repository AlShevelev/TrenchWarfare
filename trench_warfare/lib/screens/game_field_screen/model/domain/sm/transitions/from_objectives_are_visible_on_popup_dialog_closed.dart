part of game_field_sm;

class FromObjectivesAreVisibleOnPopupDialogClosed {
  final GameFieldStateMachineContext _context;

  FromObjectivesAreVisibleOnPopupDialogClosed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}