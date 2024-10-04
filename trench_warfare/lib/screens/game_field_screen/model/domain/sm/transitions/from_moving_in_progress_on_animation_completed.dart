part of game_field_sm;

class FromMovingInProgressOnAnimationCompleted extends GameObjectTransitionBase {
  FromMovingInProgressOnAnimationCompleted(super.context);

  State process(bool isVictory, Nation? defeated, Iterable<GameFieldCellRead> cellsToUpdate) {
    if (isVictory) {
      if (_context.isAI) {
        _context.controlsState.update(DefeatControls(
          nation: _context.nation,
          isGlobal: true,
        ));
      } else {
        _context.controlsState.update(WinControls(
          nation: _context.nation,
        ));
      }

      return VictoryDefeatConfirmation(isVictory: isVictory, cellsToUpdate: cellsToUpdate);
    }

    if (defeated != null) {
      _context.controlsState.update(DefeatControls(
        nation: defeated,
        isGlobal: false,
      ));

      return VictoryDefeatConfirmation(isVictory: isVictory, cellsToUpdate: cellsToUpdate);
    }

    _context.money.recalculateIncomeAndExpenses();
    return ReadyForInput();
  }
}
