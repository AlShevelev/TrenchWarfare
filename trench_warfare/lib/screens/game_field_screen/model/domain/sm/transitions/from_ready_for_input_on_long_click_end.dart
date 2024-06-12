part of game_field_sm;

class FromReadyForInputOnLongClickEnd {
  late final GameFieldStateMachineContext _context;

  FromReadyForInputOnLongClickEnd(this._context);

  State process() {
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    return ReadyForInput();
  }
}
