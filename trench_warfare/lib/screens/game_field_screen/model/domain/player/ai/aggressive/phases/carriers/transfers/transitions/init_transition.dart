part of carriers_phase_library;

class _InitTransition extends _TroopTransferTransition {
  final GameFieldCellRead _targetCell;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final ActiveCarrierTroopTransfersRead _allTransfers;

  final String _myTransferId;

  _InitTransition({
    required GameFieldCellRead targetCell,
    required GameFieldRead gameField,
    required Nation myNation,
    required ActiveCarrierTroopTransfersRead allTransfers,
    required String myTransferId,
  })  : _targetCell = targetCell,
        _gameField = gameField,
        _myNation = myNation,
        _allTransfers = allTransfers,
        _myTransferId = myTransferId;

  @override
  Future<_TransitionResult> process() async {
    final freeCarriers = _getFreeCarriers();

    // If we haven't got a free carrier - we are powerless to do anything
    if (freeCarriers.isEmpty) {
      return _TransitionResult.completed();
    }

    final selectedCarrier = _selectCarrier(freeCarriers);

    throw UnimplementedError();
  }

  /// return a list of free (unused in other transportations) carriers
  /// as a list of cells and values
  List<_CarrierOnCell> _getFreeCarriers() {
    List<_CarrierOnCell> allMyCarries = [];

    final busyCarrierId = _allTransfers
        .getAllTransfersExcept(_myTransferId)
        .where((t) => !t.isCompleted)
        .map((t) => t.selectedCarrierId)
        .where((id) => id != null)
        .toList(growable: false);

    for (final cell in _gameField.cells) {
      if (cell.nation == _myNation && cell.units.isNotEmpty) {
        allMyCarries.addAll(
          cell.units
              .where((u) => u.type == UnitType.carrier && !busyCarrierId.contains(u.id))
              .map((u) => _CarrierOnCell(carrier: u, cell: cell)),
        );
      }
    }

    return allMyCarries;
  }

  _CarrierOnCell _selectCarrier(List<_CarrierOnCell> freeCarriers) =>
    freeCarriers.map(
      (c) => Tuple2(
        c,
        UnitPowerEstimation.estimate(c.carrier) * (1.0 / _gameField.calculateDistance(_targetCell, c.cell)),
      ),
    )
    .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
    .last.item1;
}
