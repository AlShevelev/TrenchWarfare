part of game_field_sm;

class FromLoadSlotSelectionOnCancelled {
  final GameFieldStateMachineContext _context;

  FromLoadSlotSelectionOnCancelled(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}