part of game_field_sm;

class FromVictoryDefeatConfirmationOnPopupDialogClosed extends GameObjectTransitionBase {
  FromVictoryDefeatConfirmationOnPopupDialogClosed(super.context);

  State process(bool isVictory) {
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    if (isVictory) {
     return GameIsOver();
    }

    return ReadyForInput();
  }
}
