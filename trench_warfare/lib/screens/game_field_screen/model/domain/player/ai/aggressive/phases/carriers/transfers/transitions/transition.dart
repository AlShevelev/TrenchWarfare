/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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

  @protected
  final PathFacade _pathFacade;

  _TroopTransferTransition({
    required PlayerActions actions,
    required Nation myNation,
    required GameFieldRead gameField,
    required PathFacade pathFacade,
  })  : _actions = actions,
        _myNation = myNation,
        _gameField = gameField,
        _pathFacade = pathFacade;

  Future<_TransitionResult> process();

  /// Returns a result cell if unit is alive
  @protected
  Future<GameFieldCellRead?> _moveUnit(
    Unit unit, {
    required GameFieldCellRead from,
    required GameFieldCellRead to,
  }) async {
    GameFieldCellRead? unitCell = from;

    Logger.info('MOVE_UNIT: Start. unit: $unit; from: $from; To: $to', tag: 'CARRIER');
    do {
      await _actions.move(unit, from: unitCell!, to: to);
      Logger.info('MOVE_UNIT: movements completed', tag: 'CARRIER');

      unitCell = _gameField.getCellWithUnit(unit, _myNation);

      // The unit is dead
      if (unitCell == null) {
        Logger.info('MOVE_UNIT: the unit is dead', tag: 'CARRIER');
        return null;
      }

      // The cell is reached
      if (unitCell == to) {
        Logger.info('MOVE_UNIT: the cell is reached', tag: 'CARRIER');
        return to;
      }
    } while (unit.state != UnitState.disabled);

    Logger.info('MOVE_UNIT: End. result cell is: $unitCell', tag: 'CARRIER');

    return unitCell;
  }
}
