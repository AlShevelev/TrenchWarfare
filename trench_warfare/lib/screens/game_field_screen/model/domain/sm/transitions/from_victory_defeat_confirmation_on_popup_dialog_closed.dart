part of game_field_sm;

class FromVictoryDefeatConfirmationOnPopupDialogClosed extends GameObjectTransitionBase {
  FromVictoryDefeatConfirmationOnPopupDialogClosed(super.context);

  State process(bool isVictory) {
    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ),
    );

    if (isVictory) {
      return GameIsOver();
    }

    _context.money.recalculateIncomeAndExpenses();
    return ReadyForInput();
  }
}
