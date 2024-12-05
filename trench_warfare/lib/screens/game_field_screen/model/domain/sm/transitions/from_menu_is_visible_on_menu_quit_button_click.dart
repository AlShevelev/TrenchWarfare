part of game_field_sm;

class FromMenuIsVisibleOnMenuQuitButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuQuitButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.modelCallback.saveGame(GameSlot.autoSave);

    return GameIsOver();
  }
}
