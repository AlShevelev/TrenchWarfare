/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of carriers_phase_library;

class _InitTransition extends _TroopTransferTransition {
  final _StateInit _state;

  final GameFieldCellRead _transferTargetCell;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final String _myTransferId;

  _InitTransition({
    required _StateInit state,
    required GameFieldCellRead transferTargetCell,
    required super.actions,
    required super.gameField,
    required super.myNation,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required String myTransferId,
    required super.pathFacade,
  })  : _state = state,
        _transferTargetCell = transferTargetCell,
        _transfersStorage = transfersStorage,
        _myTransferId = myTransferId;

  @override
  Future<_TransitionResult> process() async {
    try {
      final selectedCarrierCell = _gameField.getCellWithUnit(_state.selectedCarrier, _myNation);
      final selectedCarrier = Tuple2<Carrier, GameFieldCellRead>(_state.selectedCarrier, selectedCarrierCell!);

      // The landing point calculation
      final landingPoint = _calculateLandingPoint(selectedCarrier);
      if (landingPoint == null) {
        Logger.info('INIT_TRANSITION: return. landingPoint == null', tag: 'CARRIER');
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
          transferTargetCell: _transferTargetCell,
          pathFacade: _pathFacade,
        ).calculate();

        // We didn't manage to find a gathering point of units
        if (gatheringPointAndUnits == null) {
          Logger.info('INIT_TRANSITION: return. [selectedCarrier.item1.units.length < GameConstants.maxUnitsInCarrier] gatheringPointAndUnits == null', tag: 'CARRIER');
          return _TransitionResult.completed();
        }
      }

      Logger.info('INIT_TRANSITION: return final. [gatheringPointAndUnits == null]: ${gatheringPointAndUnits == null}', tag: 'CARRIER');
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
          transferTargetCell: _transferTargetCell,
        ),
        canContinue: true,
      );
    } catch (e, s) {
      Logger.error('INIT_TRANSITION: error while processing. $e', tag: 'CARRIER', stackTrace: s);
      return _TransitionResult.completed();
    }
  }

  LandingPoint? _calculateLandingPoint(Tuple2<Carrier, GameFieldCellRead> selectedCarrierOnCell) {
    final selectedCarrier = selectedCarrierOnCell.item1;
    final selectedCarrierCell = selectedCarrierOnCell.item2;

    var radius = 1;
    var cellsAroundTarget = _gameField.findCellsAroundR(_transferTargetCell, radius: radius);

    final selectedCarrierCopy = Carrier.copy(selectedCarrier)
      ..addUnitAsActive(Unit.byType(UnitType.infantry));

    // If cellsAroundTarget is empty it means we've moved out of the game field borders
    while (cellsAroundTarget.isNotEmpty) {
      for (final carrierLastCellCandidate in cellsAroundTarget) {
        if (!SeaFindPathSettings.canContainSeaUnit(carrierLastCellCandidate)) {
          continue;
        }

        // We try to find a path for our carrier - from cell to cell
        final path = _pathFacade.calculatePathForUnit(
          startCell: selectedCarrierCell,
          endCell: carrierLastCellCandidate,
          calculatedUnit: selectedCarrierCopy,
        );

        // We can't reach the cell by the carrier - skip this one
        if (path.isEmpty) {
          continue;
        }

        // So, the cell if reachable by the carrier
        // Now we are looking for a landing point
        final cellsAroundLastCarrierCell = _gameField.findCellsAround(carrierLastCellCandidate);
        final ladingPointCandidates = <LandingPoint>[];
        for (final landingCellCandidate in cellsAroundLastCarrierCell) {
          final path = _pathFacade.calculatePathForUnit(
            startCell: carrierLastCellCandidate,
            endCell: landingCellCandidate,
            calculatedUnit: selectedCarrierCopy,
          );

          if (path.isEmpty) {
            continue;
          }

          final estimatedPath = _pathFacade.estimatePathForUnit(
            path: path,
            unit: selectedCarrierCopy,
          );

          final lastPathItem = estimatedPath.last.pathItem?.type;

          // The cell is reachable for the carrier as a landing point

          final landingPoint = LandingPoint(
            carrierCell: carrierLastCellCandidate,
            unitsCell: landingCellCandidate,
          );

          if (lastPathItem == PathItemType.unloadUnit &&
              _GatheringPointCalculator.isPointValid(landingPoint)) {
            ladingPointCandidates.add(landingPoint);
          }

          estimatedPath.last.setPathItem(null);
        }

        // Calculates a landing point with minimum distance to a target cell
        if (ladingPointCandidates.isNotEmpty) {
          if (ladingPointCandidates.length == 1) {
            return ladingPointCandidates.first;
          }

          double minDistanceToTargetCell = _gameField.cols.toDouble() * _gameField.rows;
          LandingPoint? ladingPoint;

          for (final ladingPointCandidate in ladingPointCandidates) {
            final distance =
                _gameField.calculateDistance(_transferTargetCell, ladingPointCandidate.unitsCell);
            if (distance < minDistanceToTargetCell) {
              minDistanceToTargetCell = distance;
              ladingPoint = ladingPointCandidate;
            }
          }

          return ladingPoint;
        }
      }
      cellsAroundTarget = _gameField.findCellsAroundR(_transferTargetCell, radius: ++radius);
    }

    return null;
  }
}
