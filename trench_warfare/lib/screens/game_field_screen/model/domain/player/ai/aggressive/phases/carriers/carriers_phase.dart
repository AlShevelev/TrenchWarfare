part of carriers_phase_library;

class CarriersPhase implements TurnPhase {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  final CarrierTroopTransfersStorage _transfersStorage;

  CarriersPhase({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
    required CarrierTroopTransfersStorage transfersStorage
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _transfersStorage = transfersStorage;

  @override
  Future<void> start() async {
    final target = CarriersTargetCalculator(
      gameField: _gameField,
      myNation: _myNation,
      metadata: _metadata,
    ).getTarget();

    if (target != null) {
      _transfersStorage.addNewTransfer(targetCell: target);
    }

    await _transfersStorage.processAll();
  }
}
