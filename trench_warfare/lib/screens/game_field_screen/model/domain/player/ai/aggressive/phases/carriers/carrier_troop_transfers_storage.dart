part of carriers_phase_library;

abstract interface class CarrierTroopTransfersStorageRead {
  Iterable<TroopTransferRead> get allTransfers;

  Iterable<TroopTransferRead> getAllTransfersExcept(String exceptionTransferId);
}

class CarrierTroopTransfersStorage implements CarrierTroopTransfersStorageRead {
  final GameFieldRead _gameField;

  final Nation _myNation;

  late PlayerActions _actions;

  final List<_TroopTransfer> _troopTransfers = [];
  int get totalTransfers => _troopTransfers.length;

  final MapMetadataRead _metadata;

  @override
  Iterable<TroopTransferRead> get allTransfers => _troopTransfers;

  CarrierTroopTransfersStorage({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata;

  void setPlayerActions(PlayerActions actions) {
    _actions = actions;

    for (final transfer in _troopTransfers) {
      transfer.setPlayerActions(_actions);
    }
  }

  void addNewTransfer({required GameFieldCellRead targetCell}) {
    final transfer = _TroopTransfer(
      targetCell: targetCell,
      transfersStorage: this,
      gameField: _gameField,
      myNation: _myNation,
      actions: _actions,
      metadata: _metadata,
    );
    _troopTransfers.add(transfer);
  }

  Future<void> processAll() async {
    for (final transfer in _troopTransfers) {
      await transfer.process();
    }

    _troopTransfers.removeWhere((t) => t.isCompleted);
  }

  @override
  Iterable<TroopTransferRead> getAllTransfersExcept(String exceptionTransferId) =>
      _troopTransfers.where((t) => t.id != exceptionTransferId).toList(growable: false);
}
