part of carriers_phase_library;

class _GatheringTransition extends _TroopTransferTransition {
  final _StateGathering _state;

  final PlayerActions _actions;

  final Nation _myNation;

  final GameFieldRead _gameField;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final String _myTransferId;

  _GatheringTransition({
    required _StateGathering state,
    required PlayerActions actions,
    required Nation myNation,
    required GameFieldRead gameField,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required String myTransferId,
  })  : _state = state,
        _actions = actions,
        _myNation = myNation,
        _gameField = gameField,
        _transfersStorage = transfersStorage,
        _myTransferId = myTransferId;

  @override
  Future<_TransitionResult> process() async {
    var state = _state.copy();

    final cellWithSelectedCarrier = _gameField.getCellWithUnit(state.selectedCarrier, _myNation);

    // The carrier is dead - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null) {
      return _TransitionResult.completed();
    }

    var carrierReachedTargetCell = false;

    // We are moving the carrier here
    if (cellWithSelectedCarrier != state.gatheringPoint.carrierCell) {
      final newCarrierCell = await _moveUnit(
        state.selectedCarrier,
        from: cellWithSelectedCarrier,
        to: state.gatheringPoint.carrierCell,
      );

      // The carrier is dead - can't make the transition
      if (newCarrierCell == null) {
        return _TransitionResult.completed();
      }
    } else {
      carrierReachedTargetCell = true;
    }

    // Check - are all the units alive?
    final aliveGatheringUnits = state.gatheringUnits
        .where((u) => _gameField.getCellWithUnit(u, _myNation) != null)
        .toList(growable: false);

    // Some units are dead and we have to fine new ones
    if (aliveGatheringUnits.length < GameConstants.maxUnitsInCarrier) {
      final unitsNeeded = GameConstants.maxUnitsInCarrier - aliveGatheringUnits.length;
      final newUnits = _findNewUnits(
        unitsNeeded,
        state.gatheringPoint.unitsCell,
        state.selectedCarrier,
      ).map((u) => u.item1);

      // Can't find full pack of the new units - we should cancel the transportation
      if (newUnits.length < unitsNeeded) {
        return _TransitionResult.completed();
      }

      // update the state
      state = state.copy(gatheringUnits: <Unit>[
        ...aliveGatheringUnits,
        ...newUnits,
      ]);
    }

    var unitsReachedTargetCellQuantity = 0;

    // Moves all the gathering units
    final gatheringUnitsCopy = <Unit>[...state.gatheringUnits];
    for (final unitToGather in state.gatheringUnits) {
      final unitToGatherCell = _gameField.getCellWithUnit(unitToGather, _myNation)!;

      // The target cell is reached - do nothing
      if (unitToGatherCell == state.gatheringPoint.unitsCell) {
        unitsReachedTargetCellQuantity++;
        continue;
      }

      final newUnitToGatherCell = await _moveUnit(
        unitToGather,
        from: unitToGatherCell,
        to: state.gatheringPoint.unitsCell,
      );

      // The unit are dead
      if (newUnitToGatherCell == null) {
        gatheringUnitsCopy.remove(unitToGather);
      } else {
        if (newUnitToGatherCell == state.gatheringPoint.unitsCell) {
          unitsReachedTargetCellQuantity++;
        }
      }
    }

    state = state.copy(gatheringUnits: gatheringUnitsCopy);

    if (carrierReachedTargetCell && unitsReachedTargetCellQuantity == GameConstants.maxUnitsInCarrier) {
      return _TransitionResult(
        newState: _StateLoadingToCarrier(
          selectedCarrier: state.selectedCarrier,
          unitsToLoad: state.gatheringUnits,
          landingPoint: state.landingPoint,
        ),
        canContinue: true,
      );
    } else {
      return _TransitionResult(
        newState: state,
        canContinue: false,
      );
    }
  }

  /// Returns a result cell if unit is alive
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

  Iterable<Tuple2<Unit, GameFieldCellRead>> _findNewUnits(
    int quantity,
    GameFieldCellRead targetCell,
    Carrier selectedCarrier,
  ) =>
      _GatheringPointCalculator(
        gameField: _gameField,
        selectedCarrier: selectedCarrier,
        myNation: _myNation,
        allTransfers: _transfersStorage,
        myTransferId: _myTransferId,
      ).calculateUnits(quantity, targetCell);
}
