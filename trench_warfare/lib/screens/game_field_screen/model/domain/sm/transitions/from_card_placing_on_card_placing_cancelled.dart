part of game_field_sm;

class FromCardPlacingOnCardPlacingCancelled {
  final GameFieldStateMachineContext _context;

  FromCardPlacingOnCardPlacingCancelled(GameFieldStateMachineContext context): _context = context;

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild) {
    TransitionUtils(_context).closeUI();

    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: {},
          oldInactiveCells: cellsImpossibleToBuild,
        )
      ]);
    }

    return ReadyForInput();
  }
}
