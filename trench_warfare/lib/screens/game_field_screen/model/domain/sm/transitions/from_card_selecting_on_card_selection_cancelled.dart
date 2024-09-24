part of game_field_sm;

class FromCardSelectingOnCardsSelectionCancelled {
  late final GameFieldStateMachineContext _context;

  FromCardSelectingOnCardsSelectionCancelled(this._context);

  State process() {
    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ),
    );

    return ReadyForInput();
  }
}
