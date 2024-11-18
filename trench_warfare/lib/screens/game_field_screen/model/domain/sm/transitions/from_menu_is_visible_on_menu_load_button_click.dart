part of game_field_sm;

class FromMenuIsVisibleOnMenuLoadButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuLoadButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(LoadControls());

    return LoadSlotSelection();
  }
}
