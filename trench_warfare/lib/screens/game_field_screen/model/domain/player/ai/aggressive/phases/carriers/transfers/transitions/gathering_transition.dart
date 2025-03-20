part of carriers_phase_library;

class _GatheringTransition extends _TroopTransferTransition {
  final _StateGathering _state;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final String _myTransferId;

  _GatheringTransition({
    required _StateGathering state,
    required super.actions,
    required super.myNation,
    required super.gameField,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required String myTransferId,
    required super.pathFacade,
  })  : _state = state,
        _transfersStorage = transfersStorage,
        _myTransferId = myTransferId;

  @override
  Future<_TransitionResult> process() async {
    var state = _state.copy();

    final cellWithSelectedCarrier = _gameField.getCellWithUnit(state.selectedCarrier, _myNation);

    // The carrier is dead - the transfer doesn't make sense
    if (cellWithSelectedCarrier == null) {
      Logger.info('GATHERING_TRANSITION: return. cellWithSelectedCarrier == null', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    // The carrier can't move in this turn
    if (_state.selectedCarrier.state == UnitState.disabled) {
      Logger.info('GATHERING_TRANSITION: return. _state.selectedCarrier.state == UnitState.disabled',
          tag: 'CARRIER');
      return _TransitionResult(newState: _state, canContinue: false);
    }

    // The target cells validation
    if (!_GatheringPointCalculator.isPointValid(state.gatheringPoint) ||
        !_GatheringPointCalculator.isPointValid(state.landingPoint)) {
      Logger.info('GATHERING_TRANSITION: return. The target cells validation fail', tag: 'CARRIER');
      return _TransitionResult.completed();
    }

    var carrierReachedTargetCell = false;

    // We are moving the carrier here
    if (cellWithSelectedCarrier != state.gatheringPoint.carrierCell) {
      // Check - can the carrier reach the target cell?
      final carrierPath = _pathFacade.calculatePathForUnit(
        startCell: cellWithSelectedCarrier,
        endCell: state.gatheringPoint.carrierCell,
        calculatedUnit: state.selectedCarrier,
      );

      // The carrier can't reach the target cell
      if (carrierPath.isEmpty) {
        Logger.info('GATHERING_TRANSITION: return. carrierPath.isEmpty', tag: 'CARRIER');
        return _TransitionResult.completed();
      }

      final newCarrierCell = await _moveUnit(
        state.selectedCarrier,
        from: cellWithSelectedCarrier,
        to: state.gatheringPoint.carrierCell,
      );

      // The carrier is dead - can't make the transition
      if (newCarrierCell == null) {
        Logger.info('GATHERING_TRANSITION: return. newCarrierCell == null', tag: 'CARRIER');
        return _TransitionResult.completed();
      }

      carrierReachedTargetCell = state.gatheringPoint.carrierCell == newCarrierCell;
    } else {
      carrierReachedTargetCell = true;
    }

    // Check - are all the units alive?
    final aliveGatheringUnits = state.gatheringUnits
        .where((u) => _gameField.getCellWithUnit(u, _myNation) != null)
        .toList(growable: false);

    // Some units are dead and we have to fine new ones
    if (aliveGatheringUnits.length < state.gatheringUnits.length) {
      final unitsNeeded = state.gatheringUnits.length - aliveGatheringUnits.length;
      final newUnits = _findNewUnits(
        quantity: unitsNeeded,
        gatheringCell: state.gatheringPoint.unitsCell,
        selectedCarrier: state.selectedCarrier,
        transferTargetCell: state.transferTargetCell,
      ).map((u) => u.item1);

      // Can't find full pack of the new units - we should cancel the transportation
      if (newUnits.length < unitsNeeded) {
        Logger.info('GATHERING_TRANSITION: return. newUnits.length < unitsNeeded', tag: 'CARRIER');
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
      Logger.info('GATHERING_TRANSITION: unitToGather processing: $unitToGather', tag: 'CARRIER');
      final unitToGatherCell = _gameField.getCellWithUnit(unitToGather, _myNation)!;
      final targetCell = state.gatheringPoint.unitsCell;
      Logger.info('GATHERING_TRANSITION: unitToGather cell: $unitToGatherCell', tag: 'CARRIER');
      Logger.info('GATHERING_TRANSITION: unitToGather target cell: $targetCell', tag: 'CARRIER');
      Logger.info('GATHERING_TRANSITION: target cell units:', tag: 'CARRIER');
      for (var i = 0; i < targetCell.units.length; i++) {
        Logger.info('GATHERING_TRANSITION: target cell unit[$i]: ${targetCell.units.elementAt(i)}', tag: 'CARRIER');
      }

      // The target cell is reached - do nothing
      if (unitToGatherCell == targetCell) {
        Logger.info('GATHERING_TRANSITION: the cell is reached', tag: 'CARRIER');
        unitsReachedTargetCellQuantity++;
        continue;
      }

      // The unit can't move - skip it
      if (unitToGather.state == UnitState.disabled ||
          !_pathFacade.canMoveForUnit(unitToGatherCell, unitToGather)) {
        Logger.info('GATHERING_TRANSITION: the unit can\'t move', tag: 'CARRIER');
        continue;
      }

      // The target cell is busy - we have to wait
      if (targetCell.units.length == GameConstants.maxUnitsInCell) {
        Logger.info('GATHERING_TRANSITION: The target cell is busy', tag: 'CARRIER');
        continue;
      }

      final newUnitToGatherCell = await _moveUnit(
        unitToGather,
        from: unitToGatherCell,
        to: targetCell,
      );

      // The unit are dead
      if (newUnitToGatherCell == null) {
        gatheringUnitsCopy.remove(unitToGather);
      } else {
        if (newUnitToGatherCell == targetCell) {
          unitsReachedTargetCellQuantity++;
        }
      }
    }

    state = state.copy(gatheringUnits: gatheringUnitsCopy);

    if (carrierReachedTargetCell && unitsReachedTargetCellQuantity == state.gatheringUnits.length) {
      Logger.info(
          'GATHERING_TRANSITION: return final. carrierReachedTargetCell && unitsReachedTargetCellQuantity == state.gatheringUnits.length',
          tag: 'CARRIER');
      return _TransitionResult(
        newState: _StateLoadingToCarrier(
          selectedCarrier: state.selectedCarrier,
          unitsToLoad: state.gatheringUnits,
          landingPoint: state.landingPoint,
        ),
        canContinue: true,
      );
    } else {
      Logger.info('GATHERING_TRANSITION: return final. else branch', tag: 'CARRIER');
      return _TransitionResult(
        newState: state,
        canContinue: false,
      );
    }
  }

  Iterable<Tuple2<Unit, GameFieldCellRead>> _findNewUnits({
    required int quantity,
    required GameFieldCellRead gatheringCell,
    required Carrier selectedCarrier,
    required GameFieldCellRead transferTargetCell,
  }) =>
      _GatheringPointCalculator(
        gameField: _gameField,
        selectedCarrier: selectedCarrier,
        myNation: _myNation,
        allTransfers: _transfersStorage,
        myTransferId: _myTransferId,
        transferTargetCell: transferTargetCell,
        pathFacade: _pathFacade,
      ).calculateUnits(quantity, gatheringCell);
}
