part of aggressive_player_ai;

abstract interface class ActiveCarrierTroopTransfersRead {
  Iterable<TroopTransferRead> get allTransfers;

  Iterable<TroopTransferRead> getAllTransfersExcept(String exceptionTransferId);
}

class ActiveCarrierTroopTransfers implements ActiveCarrierTroopTransfersRead {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final List<TroopTransfer> _troopTransfers = [];

  @override
  Iterable<TroopTransferRead> get allTransfers => _troopTransfers;

  ActiveCarrierTroopTransfers({
    required GameFieldRead gameField,
    required Nation myNation,
  })  : _gameField = gameField,
        _myNation = myNation;

  void addNewTransfer({required GameFieldCellRead targetCell}) {
    final transfer = TroopTransfer(
      targetCell: targetCell,
      allTransfers: this,
      gameField: _gameField,
      myNation: _myNation,
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
