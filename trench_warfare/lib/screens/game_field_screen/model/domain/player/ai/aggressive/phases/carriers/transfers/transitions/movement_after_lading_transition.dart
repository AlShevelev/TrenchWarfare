part of carriers_phase_library;

class _MovementAfterLadingTransition extends _TroopTransferTransition {
  final _StateMoveUnitsAfterLanding _state;

  final MapMetadataRead _metadata;

  _MovementAfterLadingTransition({
    required _StateMoveUnitsAfterLanding state,
    required super.actions,
    required super.gameField,
    required super.myNation,
    required MapMetadataRead metadata,
  })  : _state = state,
        _metadata = metadata;

  @override
  Future<_TransitionResult> process() async {
    final cellWithSelectedCarrier = _gameField.getCellWithUnit(_state.selectedCarrier, _myNation);

    // The carrier is alive
    if (cellWithSelectedCarrier != null && _state.selectedCarrier.state != UnitState.disabled) {
      Logger.info('MOVEMENT_AFTER_LADING_TRANSITION: The carrier is alive', tag: 'CARRIER');
      final carrierTargetCell = _gameField
          .findCellsAround(cellWithSelectedCarrier)
          .where((c) =>
              _gameField.findCellsAround(c).all((c) => !c.isLand) &&
              (c.nation == null || c.nation == _myNation) &&
              c.units.length < GameConstants.maxUnitsInCell)
          .firstOrNull;

      // Moves the carrier one cell out of a shore to be out of the range for land artillery units
      if (carrierTargetCell != null) {
        await _moveUnit(_state.selectedCarrier, from: cellWithSelectedCarrier, to: carrierTargetCell);
      }
      Logger.info('MOVEMENT_AFTER_LADING_TRANSITION: The carrier movement is completed', tag: 'CARRIER');
    }

    final unitCells = _state.landedUnits
        .map((u) => _gameField.getCellWithUnit(u, _myNation))
        .where((c) => c != null)
        .map((c) => c!)
        .toSet()
        .toList(growable: false);

    Logger.info('MOVEMENT_AFTER_LADING_TRANSITION: Units movement phase is started', tag: 'CARRIER');
    await UnitsMovingPhase.withActions(
      actions: _actions,
      gameField: _gameField,
      myNation: _myNation,
      metadata: _metadata,
      iterator: StableUnitsIterator.fromCell(unitCells),
      aiProgressState: null,
    ).start();
    Logger.info('MOVEMENT_AFTER_LADING_TRANSITION: Units movement phase is completed', tag: 'CARRIER');
    return _TransitionResult.completed();
  }
}
