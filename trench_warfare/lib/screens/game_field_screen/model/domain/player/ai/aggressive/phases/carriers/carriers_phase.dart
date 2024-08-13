part of carriers_phase_library;

class CarriersPhase implements TurnPhase {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  final ActiveCarrierTroopTransfers _activeCarrierTroopTransfers;

  CarriersPhase({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
    required ActiveCarrierTroopTransfers activeCarrierTroopTransfers
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _activeCarrierTroopTransfers = activeCarrierTroopTransfers;

  @override
  Future<void> start() async {
    final target = CarriersTargetCalculator(
      gameField: _gameField,
      myNation: _myNation,
      metadata: _metadata,
    ).getTarget();

    if (target != null) {
      _activeCarrierTroopTransfers.addNewTransfer(targetCell: target);
    }

    await _activeCarrierTroopTransfers.processAll();
  }
}
