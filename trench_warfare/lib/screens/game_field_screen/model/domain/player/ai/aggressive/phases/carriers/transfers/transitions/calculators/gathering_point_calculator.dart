part of carriers_phase_library;

class _GatheringPointCalculator {
  final GameFieldRead _gameField;

  final _CarrierOnCell _selectedCarrier;

  final Nation _myNation;

  final Iterable<TroopTransferRead> _otherTransfers;

  _GatheringPointCalculator({
    required GameFieldRead gameField,
    required _CarrierOnCell selectedCarrier,
    required Nation myNation,
    required ActiveCarrierTroopTransfersRead allTransfers,
    required String myTransferId,
  })  : _gameField = gameField,
        _selectedCarrier = selectedCarrier,
        _myNation = myNation,
        _otherTransfers = allTransfers.getAllTransfersExcept(myTransferId);

  _GatheringPointAndUnits? calculate() {
    final unitsNeeded = GameConstants.maxUnitsInCarrier - _selectedCarrier.carrier.units.length;

    final otherTransferPoints = <LandingPoint>[
      ..._otherTransfers.where((t) => t.landingPoint != null).map((t) => t.landingPoint!),
      ..._otherTransfers.where((t) => t.gatheringPoint != null).map((t) => t.gatheringPoint!)
    ];

    final otherTransferCarrierPoints = otherTransferPoints.map((c) => c.carrierCell).toList(growable: false);
    final otherTransferUnitsPoints = otherTransferPoints.map((c) => c.unitsCell).toList(growable: false);

    // Looking for all my land cells with units
    final allMyCellWithUnits = _gameField.cells
        .where((c) => c.nation == _myNation && c.isLand && c.units.isNotEmpty && c.productionCenter == null)
        .toList(growable: false);

    // We are looking for all cell ashore and sorting them ascending
    // by a distance from the cell to the carrier
    final allCellsAshore = _gameField.cells
        .where((c) =>
            !c.isLand &&
            c.productionCenter == null &&
            c.terrainModifier == null &&
            c.units.isEmpty &&
            !otherTransferCarrierPoints.contains(c) &&
            _gameField.findCellsAround(c).any((c) => c.isLand))
        .map((ca) => Tuple2(ca, _gameField.calculateDistance(ca, _selectedCarrier.cell)))
        .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
        .map((i) => i.item1)
        .toList(growable: false);

    final pathFacade = PathFacade(_gameField);

    for (final carrierCellCandidate in allCellsAshore) {
      final allLandCellsAround = _gameField
          .findCellsAround(carrierCellCandidate)
          .where((c) =>
              c.isLand &&
              !c.hasRiver &&
              c.productionCenter == null &&
              c.terrainModifier == null &&
              c.units.isEmpty &&
              !otherTransferUnitsPoints.contains(c))
          .toList(growable: false);

      for (final landCellCandidate in allLandCellsAround) {
        final selectedUnitCandidates = <Unit>[];

        final allMyCellWithUnitsSorted = allMyCellWithUnits
            .map((c) => Tuple2(c, _gameField.calculateDistance(c, landCellCandidate)))
            .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
            .map((i) => i.item1)
            .toList(growable: false);

        for (final cellWithUnit in allMyCellWithUnitsSorted) {
          for (final unitCandidate in cellWithUnit.units) {
            if (!unitCandidate.isLand) {
              continue;
            }

            final path = pathFacade.calculatePathForUnit(
              startCell: cellWithUnit,
              endCell: landCellCandidate,
              calculatedUnit: unitCandidate,
            );

            if (path.isNotEmpty) {
              selectedUnitCandidates.add(unitCandidate);
            }

            if (selectedUnitCandidates.length == unitsNeeded) {
              return _GatheringPointAndUnits(
                gatheringPoint: LandingPoint(
                  carrierCell: carrierCellCandidate,
                  unitsCell: landCellCandidate,
                ),
                units: selectedUnitCandidates,
              );
            }
          }
        }
      }
    }
    return null;
  }
}
