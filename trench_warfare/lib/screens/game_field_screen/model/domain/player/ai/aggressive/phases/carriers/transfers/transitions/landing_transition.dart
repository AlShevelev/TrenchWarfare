part of carriers_phase_library;

class _LandingTransition extends _TroopTransferTransition {
  final _StateLanding _state;

  _LandingTransition({
    required super.actions,
    required super.gameField,
    required super.myNation,
    required _StateLanding state,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    final cellWithSelectedCarrier = _gameField.getCellWithUnit(_state.selectedCarrier, _myNation);

    // The carrier is dead or out of the landing cell - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null || cellWithSelectedCarrier != _state.landingPoint.carrierCell) {
      return _TransitionResult.completed();
    }

    // Checking to mine fields
    if (!_isPointValid(_state.landingPoint)) {
      return _TransitionResult.completed();
    }

    final unitsTotal = _state.selectedCarrier.units.length;

    // Landing
    for (var i = 0; i < unitsTotal; i++) {
      await _actions.move(
        _state.selectedCarrier,
        from: cellWithSelectedCarrier,
        to: _state.landingPoint.unitsCell,
      );
    }

    if (_state.selectedCarrier.units.isNotEmpty) {
      // Some of the units are in a carrier
      return _TransitionResult(newState: _state, canContinue: false);
    } else {
      return _TransitionResult(
        newState: _StateMoveUnitsAfterLanding(
          selectedCarrier: _state.selectedCarrier,
          landedUnits: <Unit>[..._state.landingPoint.unitsCell.units],
        ),
        canContinue: true,
      );
    }
  }
}
