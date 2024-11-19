part of game_field_sm;

class TransitionUtils {
  final GameFieldStateMachineContext _context;

  TransitionUtils(GameFieldStateMachineContext context) : _context = context;

  void closeUI() {
    _context.controlsState.update(MainControls(
      totalSum: _context.money.totalSum,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));
  }
}