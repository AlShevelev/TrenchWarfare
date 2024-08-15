part of carriers_phase_library;

class _InitTransitionResult {
  final _CarrierOnCell selectedCarrier;

  final LandingPoint? landingPoint;

  final _GatheringPointAndUnits? gatheringPointAndUnits;

  _InitTransitionResult({
    required this.selectedCarrier,
    required this.landingPoint,
    required this.gatheringPointAndUnits,
  });
}

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

    // The landing point calculation
    final landingPoint = _calculateLandingCell(selectedCarrier);
    if (landingPoint == null) {
      return _TransitionResult.completed();
    }

    _GatheringPointAndUnits? gatheringPointAndUnits;
    if (selectedCarrier.carrier.units.length < GameConstants.maxUnitsInCarrier) {
      gatheringPointAndUnits = _GatheringPointCalculator(
        gameField: _gameField,
        selectedCarrier: selectedCarrier,
        myNation: _myNation,
        allTransfers: _allTransfers,
        myTransferId: _myTransferId,
      ).calculate();

      // We didn't manage to find a gathering point of units
      if (gatheringPointAndUnits == null) {
        return _TransitionResult.completed();
      }
    }

    return _TransitionResultPayload(
      processed: false,
      newState:
          gatheringPointAndUnits == null ? _TroopTransferStateTransporting() : _TroopTransferStateGathering(),
      payload: _InitTransitionResult(
        selectedCarrier: selectedCarrier,
        landingPoint: landingPoint,
        gatheringPointAndUnits: gatheringPointAndUnits,
      ),
    );
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
              .map((u) => _CarrierOnCell(carrier: u as Carrier, cell: cell)),
        );
      }
    }

    return allMyCarries;
  }

  _CarrierOnCell _selectCarrier(List<_CarrierOnCell> freeCarriers) => freeCarriers
      .map(
        (c) => Tuple2(
          c,
          UnitPowerEstimation.estimate(c.carrier) * (1.0 / _gameField.calculateDistance(_targetCell, c.cell)),
        ),
      )
      .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
      .last
      .item1;

  LandingPoint? _calculateLandingCell(_CarrierOnCell selectedCarrier) {
    var radius = 1;
    var cellsAroundTarget = _gameField.findCellsAroundR(_targetCell, radius: radius);

    final pathFacade = PathFacade(_gameField);

    // If cellsAroundTarget is empty it means we've moved out of the game field borders
    while (cellsAroundTarget.isNotEmpty) {
      for (final carrierLastCellCandidate in cellsAroundTarget) {
        // We try to find a path for our carrier - from cell to cell
        final path = pathFacade.calculatePathForUnit(
          startCell: selectedCarrier.cell,
          endCell: carrierLastCellCandidate,
          calculatedUnit: selectedCarrier.carrier,
        );

        // We can't reach the cell by the carrier - skip this one
        if (path.isEmpty) {
          continue;
        }

        // So, the cell if reachable by the carrier
        // Now we are looking for a landing point
        final cellsAroundLastCarrierCell = _gameField.findCellsAround(carrierLastCellCandidate);
        for (final landingCellCandidate in cellsAroundLastCarrierCell) {
          final path = pathFacade.calculatePathForUnit(
            startCell: carrierLastCellCandidate,
            endCell: landingCellCandidate,
            calculatedUnit: selectedCarrier.carrier,
          );

          if (path.isEmpty) {
            continue;
          }

          final lastPathItem = pathFacade
              .estimatePathForUnit(
                path: path,
                unit: selectedCarrier.carrier,
              )
              .last
              .pathItem
              ?.type;

          // The cell is reachable for the carrier as a landing point
          if (lastPathItem == PathItemType.unloadUnit) {
            return LandingPoint(carrierCell: carrierLastCellCandidate, unitsCell: landingCellCandidate);
          }
        }
      }

      cellsAroundTarget = _gameField.findCellsAroundR(_targetCell, radius: ++radius);
    }

    return null;
  }
}
