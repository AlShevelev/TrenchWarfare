part of game_field_sm;

class FromSaveSlotSelectionOnCancelled {
  final GameFieldStateMachineContext _context;

  FromSaveSlotSelectionOnCancelled(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}