part of carriers_phase_library;

class _TransitionResult {
  final _TroopTransferState newState;

  final bool canContinue;

  _TransitionResult({required this.newState, required this.canContinue});

  _TransitionResult.completed()
      : newState = _StateCompleted(),
        canContinue = false;
}

abstract interface class _TroopTransferTransition {
  @protected
  final PlayerActions _actions;

  @protected
  final Nation _myNation;

  @protected
  final GameFieldRead _gameField;

  _TroopTransferTransition({
    required PlayerActions actions,
    required Nation myNation,
    required GameFieldRead gameField,
  })  : _actions = actions,
        _myNation = myNation,
        _gameField = gameField;

  Future<_TransitionResult> process();

  /// Returns a result cell if unit is alive
  @protected
  Future<GameFieldCellRead?> _moveUnit(
    Unit unit, {
    required GameFieldCellRead from,
    required GameFieldCellRead to,
  }) async {
    GameFieldCellRead? unitCell = from;

    do {
      await _actions.move(unit, from: unitCell!, to: to);

      unitCell = _gameField.getCellWithUnit(unit, _myNation);

      // The unit is dead
      if (unitCell == null) {
        return null;
      }

      // The cell is reached
      if (unitCell == to) {
        return to;
      }
    } while (unit.state != UnitState.disabled);

    return unitCell;
  }
}
