part of game_field_sm;

class FromMenuIsVisibleOnPhoneBackAction {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnPhoneBackAction(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(MainControls(
      totalSum: _context.money.totalSum,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    return ReadyForInput();
  }
}
