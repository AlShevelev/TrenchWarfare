part of game_field_sm;

class FromMenuIsVisibleOnMenuSaveButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuSaveButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(SaveControls());

    return SaveSlotSelection();
  }
}
