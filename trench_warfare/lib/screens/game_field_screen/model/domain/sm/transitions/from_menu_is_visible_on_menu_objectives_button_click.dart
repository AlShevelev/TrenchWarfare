part of game_field_sm;

class FromMenuIsVisibleOnMenuObjectivesButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuObjectivesButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(ObjectivesControls(
      nations: _context.mapMetadata.getEnemies(_context.myNation),
    ));

    return ObjectivesAreVisible();
  }
}
