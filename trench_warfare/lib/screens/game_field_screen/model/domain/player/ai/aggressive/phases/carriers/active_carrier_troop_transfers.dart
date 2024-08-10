part of aggressive_player_ai;

interface class ActiveCarrierTroopTransfersRequests {
  // market cells, troops etc.
}

class ActiveCarrierTroopTransfers implements ActiveCarrierTroopTransfersRequests {
  final List<TroopTransfer> _troopTransfers = [];

  void addNewTransfer({required GameFieldCellRead targetCell}) {
    final transfer = TroopTransfer(targetCell: targetCell, otherTransferRequests: this);
    _troopTransfers.add(transfer);
  }

  Future<void> processAll() async {
    for (final transfer in _troopTransfers) {
      await transfer.process();
    }

    _troopTransfers.removeWhere((t) => t.isCompleted);
  }
}