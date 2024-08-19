part of carriers_phase_library;

class _InitTransition extends _TroopTransferTransition {
  final GameFieldCellRead _targetCell;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final String _myTransferId;

  _InitTransition({
    required GameFieldCellRead targetCell,
    required super.actions,
    required super.gameField,
    required super.myNation,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required String myTransferId,
  })  : _targetCell = targetCell,
        _transfersStorage = transfersStorage,
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

    Tuple2<LandingPoint, List<Unit>>? gatheringPointAndUnits;
    if (selectedCarrier.item1.units.length < GameConstants.maxUnitsInCarrier) {
      gatheringPointAndUnits = _GatheringPointCalculator(
        gameField: _gameField,
        selectedCarrier: selectedCarrier.item1,
        myNation: _myNation,
        allTransfers: _transfersStorage,
        myTransferId: _myTransferId,
      ).calculate();

      // We didn't manage to find a gathering point of units
      if (gatheringPointAndUnits == null) {
        return _TransitionResult.completed();
      }
    }

    return gatheringPointAndUnits == null
        ? _TransitionResult(
            newState: _StateTransporting(
              selectedCarrier: selectedCarrier.item1,
              landingPoint: landingPoint,
            ),
            canContinue: true,
          )
        : _TransitionResult(
            newState: _StateGathering(
              selectedCarrier: selectedCarrier.item1,
              landingPoint: landingPoint,
              gatheringPoint: gatheringPointAndUnits.item1,
              gatheringUnits: gatheringPointAndUnits.item2,
            ),
            canContinue: true,
          );
  }

  /// return a list of free (unused in other transportations) carriers
  /// as a list of cells and values
  List<Tuple2<Carrier, GameFieldCellRead>> _getFreeCarriers() {
    var allMyCarries = <Tuple2<Carrier, GameFieldCellRead>>[];

    final busyCarrierId = _transfersStorage
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
              .map((u) => Tuple2(u as Carrier, cell)),
        );
      }
    }

    return allMyCarries;
  }

  Tuple2<Carrier, GameFieldCellRead> _selectCarrier(List<Tuple2<Carrier, GameFieldCellRead>> freeCarriers) =>
      freeCarriers
          .map(
            (c) => Tuple2(
              c,
              UnitPowerEstimation.estimate(c.item1) *
                  (1.0 / _gameField.calculateDistance(_targetCell, c.item2)),
            ),
          )
          .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
          .last
          .item1;

  LandingPoint? _calculateLandingCell(Tuple2<Carrier, GameFieldCellRead> selectedCarrierOnCell) {
    final selectedCarrier = selectedCarrierOnCell.item1;
    final selectedCarrierCell = selectedCarrierOnCell.item2;

    var radius = 1;
    var cellsAroundTarget = _gameField.findCellsAroundR(_targetCell, radius: radius);

    final pathFacade = PathFacade(_gameField);

    // If cellsAroundTarget is empty it means we've moved out of the game field borders
    while (cellsAroundTarget.isNotEmpty) {
      for (final carrierLastCellCandidate in cellsAroundTarget) {
        // We try to find a path for our carrier - from cell to cell
        final path = pathFacade.calculatePathForUnit(
          startCell: selectedCarrierCell,
          endCell: carrierLastCellCandidate,
          calculatedUnit: selectedCarrier,
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
            calculatedUnit: selectedCarrier,
          );

          if (path.isEmpty) {
            continue;
          }

          final lastPathItem = pathFacade
              .estimatePathForUnit(
                path: path,
                unit: selectedCarrier,
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
