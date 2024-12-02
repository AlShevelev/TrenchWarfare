part of game_field_sm;

class FromSaveSlotSelectionOnSaveSlotSelected {
  final GameFieldStateMachineContext _context;

  final GameSlot _slot;

  FromSaveSlotSelectionOnSaveSlotSelected(this._context, GameSlot slot) : _slot = slot;

  State process() {
    TransitionUtils(_context).closeUI();

    _context.modelCallback.saveGame(_slot, isAutosave: false);

    return ReadyForInput();
  }
}