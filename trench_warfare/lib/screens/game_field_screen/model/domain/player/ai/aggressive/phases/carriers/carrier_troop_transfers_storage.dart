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

  final SimpleStream<GameFieldControlsState> _aiProgressState;

  CarrierTroopTransfersStorage({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
    required Iterable<TroopTransferReadForSaving> initialTransfers,
    required SimpleStream<GameFieldControlsState> aiProgressState,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata,
        _aiProgressState = aiProgressState {
    for (final initialTransfer in initialTransfers) {
      _troopTransfers.add(_TroopTransfer.fromSaving(
        saving: initialTransfer,
        transfersStorage: this,
        gameField: gameField,
        myNation: myNation,
        metadata: metadata,
      ));
    }
  }

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
    _updateControlStateProgress(0.0);

    int counter = 0;
    for (final transfer in _troopTransfers) {
      _updateControlStateProgress(++counter / _troopTransfers.length.toDouble());
      await transfer.process();
    }

    if (_troopTransfers.isNotEmpty) {
      _updateControlStateProgress(1.0);
    }

    _troopTransfers.removeWhere((t) => t.isCompleted);
  }

  @override
  Iterable<TroopTransferRead> getAllTransfersExcept(String exceptionTransferId) =>
      _troopTransfers.where((t) => t.id != exceptionTransferId).toList(growable: false);

  void _updateControlStateProgress(double value) => _aiProgressState.current
      ?.let((c) => _aiProgressState.update((c as AiTurnProgress).copy(carriers: value)));
}
