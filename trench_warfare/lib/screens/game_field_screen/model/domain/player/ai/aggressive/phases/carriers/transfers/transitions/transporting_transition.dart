part of carriers_phase_library;

class _TransportingTransition extends _TroopTransferTransition {
  final _StateTransporting _state;

  _TransportingTransition({
    required _StateTransporting state,
    required super.actions,
    required super.myNation,
    required super.gameField,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    final cellWithSelectedCarrier = _gameField.getCellWithUnit(_state.selectedCarrier, _myNation);

    // The carrier is dead - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null) {
      return _TransitionResult.completed();
    }

    if (!_GatheringPointCalculator.isPointValid(_state.landingPoint)) {
      return _TransitionResult.completed();
    }

    // The carrier can't move in this turn
    if (_state.selectedCarrier.state == UnitState.disabled) {
      return _TransitionResult(newState: _state, canContinue: false);
    }

    final pathFacade = PathFacade(_gameField);
    final carrierPath = pathFacade.calculatePathForUnit(
      startCell: cellWithSelectedCarrier,
      endCell: _state.landingPoint.carrierCell,
      calculatedUnit: _state.selectedCarrier,
    );

    // The carrier can't reach the target cell
    if (carrierPath.isEmpty) {
      return _TransitionResult.completed();
    }

    final resultCell = await _moveUnit(
      _state.selectedCarrier,
      from: cellWithSelectedCarrier,
      to: _state.landingPoint.carrierCell,
    );

    // The carried has been destroyed during the moving (due to a mine field, for exemple)
    if (resultCell == null) {
      return _TransitionResult.completed();
    }

    if (resultCell == _state.landingPoint.carrierCell) {
      return _TransitionResult(
        newState: _StateLanding(
          selectedCarrier: _state.selectedCarrier,
          landingPoint: _state.landingPoint,
        ),
        canContinue: _state.selectedCarrier.state != UnitState.disabled,
      );
    } else {
      return _TransitionResult(newState: _state, canContinue: false);
    }
  }
}
