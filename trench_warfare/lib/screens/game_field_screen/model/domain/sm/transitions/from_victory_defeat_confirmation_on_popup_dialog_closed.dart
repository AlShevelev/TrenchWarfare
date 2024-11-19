part of game_field_sm;

class FromVictoryDefeatConfirmationOnPopupDialogClosed extends GameObjectTransitionBase {
  FromVictoryDefeatConfirmationOnPopupDialogClosed(super.context);

  State process(bool isVictory, Iterable<GameFieldCellRead> cellsToUpdate) {
    TransitionUtils(_context).closeUI();

    if (isVictory) {
      return GameIsOver();
    }

    _context.money.recalculateIncomeAndExpenses();

    // Clear all the cell of the defeated nation
    final events = cellsToUpdate
        .map((c) => UpdateCell(c as GameFieldCell, updateBorderCells: []))
        .toList(growable: false);
    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
