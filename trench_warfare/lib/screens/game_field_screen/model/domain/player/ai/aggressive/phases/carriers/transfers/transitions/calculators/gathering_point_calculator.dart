part of carriers_phase_library;

class _GatheringPointCalculator {
  final GameFieldRead _gameField;

  final Carrier _selectedCarrier;

  final Nation _myNation;

  final CarrierTroopTransfersStorageRead _allTransfers;

  final String _myTransferId;

  final GameFieldCellRead _transferTargetCell;

  final PathFacade _pathFacade;

  _GatheringPointCalculator({
    required GameFieldRead gameField,
    required Carrier selectedCarrier,
    required Nation myNation,
    required CarrierTroopTransfersStorageRead allTransfers,
    required String myTransferId,
    required GameFieldCellRead transferTargetCell,
    required PathFacade pathFacade,
  })  : _gameField = gameField,
        _selectedCarrier = selectedCarrier,
        _myNation = myNation,
        _allTransfers = allTransfers,
        _myTransferId = myTransferId,
        _transferTargetCell = transferTargetCell,
        _pathFacade = pathFacade;

  /// Returns gathering point and units
  Tuple2<LandingPoint, List<Unit>>? calculate() {
    final unitsNeeded = GameConstants.maxUnitsInCarrier - _selectedCarrier.units.length;

    final otherTransfers = _allTransfers.getAllTransfersExcept(_myTransferId);

    final otherTransferPoints = <LandingPoint>[
      ...otherTransfers.where((t) => t.landingPoint != null).map((t) => t.landingPoint!),
      ...otherTransfers.where((t) => t.gatheringPoint != null).map((t) => t.gatheringPoint!)
    ];

    final allTransportingUnis = _getAllTransportingUnits(otherTransfers);

    final otherTransferCarrierPoints = otherTransferPoints.map((c) => c.carrierCell).toList(growable: false);
    final otherTransferUnitsPoints = otherTransferPoints.map((c) => c.unitsCell).toList(growable: false);

    // Looking for all my land cells with units
    final allMyCellWithUnits = _gameField.cells
        .where((c) => c.nation == _myNation && c.isLand && c.units.isNotEmpty)
        .toList(growable: false);

    final selectedCarrierCell = _gameField.getCellWithUnit(_selectedCarrier, _myNation)!;

    // We are looking for all cell ashore and sorting them ascending
    // by a distance from the cell to the carrier
    final allCellsAshore = _gameField.cells
        .where((c) =>
            !c.isLand &&
            c.productionCenter == null &&
            c.units.isEmpty &&
            c.terrainModifier?.type != TerrainModifierType.seaMine &&
            !otherTransferCarrierPoints.contains(c) &&
            _gameField.findCellsAround(c).any((c) => c.isLand))
        .map((ca) => Tuple2(ca, _gameField.calculateDistance(ca, selectedCarrierCell)))
        .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
        .map((i) => i.item1)
        .toList(growable: false);

    for (final carrierCellCandidate in allCellsAshore) {
      final allLandCellsAround = _gameField
          .findCellsAround(carrierCellCandidate)
          .where((c) =>
              c.isLand &&
              !c.hasRiver &&
              c.productionCenter == null &&
              c.units.isEmpty &&
              c.terrainModifier?.type != TerrainModifierType.landMine &&
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
            if (!unitCandidate.isLand || unitCandidate.isInDefenceMode) {
              continue;
            }

            // Check a path to the landing cell
            final pathToLandCell = _pathFacade.calculatePathForUnit(
              startCell: cellWithUnit,
              endCell: landCellCandidate,
              calculatedUnit: unitCandidate,
            );

            if (pathToLandCell.isNotEmpty && !allTransportingUnis.contains(unitCandidate)) {
              // Check a path to the target cell
              final pathToTargetCell = _pathFacade.calculatePathForUnit(
                startCell: cellWithUnit,
                endCell: _transferTargetCell,
                calculatedUnit: unitCandidate,
              );

              // If the unit has a path to the target cell we should exclude it -
              // it can reach the target cell without a carrier
              if (pathToTargetCell.isEmpty && selectedUnitCandidates.length < unitsNeeded) {
                selectedUnitCandidates.add(unitCandidate);
              }
            }

            final landingPoint = LandingPoint(
              carrierCell: carrierCellCandidate,
              unitsCell: landCellCandidate,
            );

            if (selectedUnitCandidates.length == unitsNeeded && isPointValid(landingPoint)) {
              return Tuple2(
                landingPoint,
                selectedUnitCandidates,
              );
            }
          }
        }
      }
    }
    return null;
  }

  /// Calculate units only (without the result key)
  Iterable<Tuple2<Unit, GameFieldCellRead>> calculateUnits(int quantity, GameFieldCellRead gatheringCell) {
    final allTransportingUnis = _getAllTransportingUnits(_allTransfers.allTransfers);

    final result = <Tuple2<Unit, GameFieldCellRead>>[];

    // Looking for all my land cells with units
    final allMyCellWithUnits = _gameField.cells
        .where((c) => c.nation == _myNation && c.isLand && c.units.isNotEmpty && c.productionCenter == null)
        .toList(growable: false);

    final allMyCellWithUnitsSorted = allMyCellWithUnits
        .map((c) => Tuple2(c, _gameField.calculateDistance(c, gatheringCell)))
        .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
        .map((i) => i.item1)
        .toList(growable: false);

    for (final cellWithUnit in allMyCellWithUnitsSorted) {
      for (final unitCandidate in cellWithUnit.units) {
        if (!unitCandidate.isLand || unitCandidate.isInDefenceMode) {
          continue;
        }

        // Check a path to the gathering cell
        final path = _pathFacade.calculatePathForUnit(
          startCell: cellWithUnit,
          endCell: gatheringCell,
          calculatedUnit: unitCandidate,
        );

        if (path.isNotEmpty && !allTransportingUnis.contains(unitCandidate)) {
          // Check a path to the target cell
          final pathToTargetCell = _pathFacade.calculatePathForUnit(
            startCell: cellWithUnit,
            endCell: _transferTargetCell,
            calculatedUnit: unitCandidate,
          );

          // If the unit has a path to the target cell we should exclude it -
          // it can reach the target cell without a carrier
          if (pathToTargetCell.isEmpty && result.length < quantity) {
            result.add(Tuple2(unitCandidate, cellWithUnit));
          }
        }

        if (result.length == quantity) {
          return result;
        }
      }
    }

    return result;
  }

  static bool isPointValid(LandingPoint point) =>
      point.carrierCell.terrainModifier?.type != TerrainModifierType.seaMine &&
      point.unitsCell.terrainModifier?.type != TerrainModifierType.landMine &&
      point.carrierCell.productionCenter == null &&
      point.unitsCell.productionCenter == null;

  Iterable<Unit> _getAllTransportingUnits(Iterable<TroopTransferRead> transfers) =>
      transfers.map((t) => t.transportingUnits).expand((i) => i).map((u) => u).toList(growable: false);
}
