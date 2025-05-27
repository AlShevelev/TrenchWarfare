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

class _TransportingTransition extends _TroopTransferTransition {
  final _StateTransporting _state;

  _TransportingTransition({
    required _StateTransporting state,
    required super.actions,
    required super.myNation,
    required super.gameField,
    required super.pathFacade,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    final cellWithSelectedCarrier = _gameField.getCellWithUnit(_state.selectedCarrier, _myNation);

    // The carrier is dead - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null) {
      Logger.info('TRANSPORTING_TRANSITION: return. cellWithSelectedCarrier == null', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    if (!_GatheringPointCalculator.isPointValid(_state.landingPoint)) {
      Logger.info('TRANSPORTING_TRANSITION: return. !_GatheringPointCalculator.isPointValid(_state.landingPoint)', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    // The carrier can't move in this turn
    if (_state.selectedCarrier.state == UnitState.disabled) {
      Logger.info('TRANSPORTING_TRANSITION: return. _state.selectedCarrier.state == UnitState.disabled', tag: 'CARRIER');
      return _TransitionResult(newState: _state, canContinue: false);
    }

    final carrierPath = _pathFacade.calculatePathForUnit(
      startCell: cellWithSelectedCarrier,
      endCell: _state.landingPoint.carrierCell,
      calculatedUnit: _state.selectedCarrier,
    );

    // The carrier can't reach the target cell
    if (carrierPath.isEmpty) {
      Logger.info('TRANSPORTING_TRANSITION: return. carrierPath.isEmpty', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    final resultCell = await _moveUnit(
      _state.selectedCarrier,
      from: cellWithSelectedCarrier,
      to: _state.landingPoint.carrierCell,
    );

    // The carried has been destroyed during the moving (due to a mine field, for exemple)
    if (resultCell == null) {
      Logger.info('TRANSPORTING_TRANSITION: return. resultCell == null', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    if (resultCell == _state.landingPoint.carrierCell) {
      Logger.info('TRANSPORTING_TRANSITION: return final. resultCell == _state.landingPoint.carrierCell', tag: 'CARRIER');
      return _TransitionResult(
        newState: _StateLanding(
          selectedCarrier: _state.selectedCarrier,
          landingPoint: _state.landingPoint,
        ),
        canContinue: _state.selectedCarrier.state != UnitState.disabled,
      );
    } else {
      Logger.info('TRANSPORTING_TRANSITION: return final. else branch', tag: 'CARRIER');
      return _TransitionResult(newState: _state, canContinue: false);
    }
  }
}
