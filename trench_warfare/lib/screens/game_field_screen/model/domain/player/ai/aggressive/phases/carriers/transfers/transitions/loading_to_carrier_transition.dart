part of carriers_phase_library;

class _LoadingToCarrierTransition extends _TroopTransferTransition {
  final _StateLoadingToCarrier _state;

  _LoadingToCarrierTransition({
    required _StateLoadingToCarrier state,
    required super.actions,
    required super.myNation,
    required super.gameField,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    var state = _state.copy();

    final cellWithSelectedCarrier = _gameField.getCellWithUnit(state.selectedCarrier, _myNation);

    // The carrier is dead - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null) {
      return _TransitionResult.completed();
    }

    // Checking to mine fields
    if (!_GatheringPointCalculator.isPointValid(_state.landingPoint)) {
      return _TransitionResult.completed();
    }

    final unitsOnCells = state.unitsToLoad
        .map((u) => Tuple2(u, _gameField.getCellWithUnit(u, _myNation)))
        .toList(growable: false);

    // Some units was killed - the transfer doesn't make sense
    if (unitsOnCells.any((u) => u.item2 == null)) {
      return _TransitionResult.completed();
    }

    // An empty path means something weird happened (for example, the carrier has flown away due to
    // attack by some enemy unit)
    final pathFacade = PathFacade(_gameField);
    final paths = unitsOnCells.map((u) => pathFacade.calculatePathForUnit(
          startCell: u.item2!,
          endCell: cellWithSelectedCarrier,
          calculatedUnit: u.item1,
        ));
    if (paths.any((p) => p.isEmpty)) {
      return _TransitionResult.completed();
    }

    // Moves the units
    for (final unitOnCell in unitsOnCells) {
      if (unitOnCell.item1.state != UnitState.disabled) {
        await _actions.move(
          unitOnCell.item1,
          from: unitOnCell.item2!,
          to: cellWithSelectedCarrier,
        );
      }
    }

    if (state.selectedCarrier.units.length == state.unitsToLoad.length) {
      // All the units have been loaded - we can transport them now
      return _TransitionResult(
        newState: _StateTransporting(
          selectedCarrier: state.selectedCarrier,
          landingPoint: state.landingPoint,
        ),
        canContinue: true,
      );
    } else {
      // Some units hava not been loaded - we can do it in the next turn
      final newUnitsToLoad = <Unit>[...state.unitsToLoad];
      final loadedUnitsId = state.selectedCarrier.units.map((u) => u.id).toList(growable: false);

      newUnitsToLoad.removeWhere((u) => loadedUnitsId.contains(u.id));

      return _TransitionResult(
        newState: state.copy(unitsToLoad: newUnitsToLoad),
        canContinue: false,
      );
    }
  }
}
