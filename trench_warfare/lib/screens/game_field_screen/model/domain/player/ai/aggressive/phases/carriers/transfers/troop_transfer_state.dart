part of carriers_phase_library;

sealed class _TroopTransferState {}

class _StateInit extends _TroopTransferState {}

class _StateGathering extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  final LandingPoint gatheringPoint;

  final List<Unit> gatheringUnits;

  final GameFieldCellRead transferTargetCell;

  _StateGathering({
    required this.selectedCarrier,
    required this.landingPoint,
    required this.gatheringPoint,
    required this.gatheringUnits,
    required this.transferTargetCell,
  });

  _StateGathering copy({
    Carrier? selectedCarrier,
    LandingPoint? landingPoint,
    LandingPoint? gatheringPoint,
    List<Unit>? gatheringUnits,
    GameFieldCellRead? transferTargetCell,
  }) =>
      _StateGathering(
        selectedCarrier: selectedCarrier ?? this.selectedCarrier,
        landingPoint: landingPoint ?? this.landingPoint,
        gatheringPoint: gatheringPoint ?? this.gatheringPoint,
        gatheringUnits: gatheringUnits ?? this.gatheringUnits,
        transferTargetCell: transferTargetCell ?? this.transferTargetCell,
      );
}

class _StateLoadingToCarrier extends _TroopTransferState {
  final Carrier selectedCarrier;

  final List<Unit> unitsToLoad;

  final LandingPoint landingPoint;

  _StateLoadingToCarrier({
    required this.selectedCarrier,
    required this.unitsToLoad,
    required this.landingPoint,
  });

  _StateLoadingToCarrier copy({
    Carrier? selectedCarrier,
    List<Unit>? unitsToLoad,
    LandingPoint? landingPoint,
  }) =>
      _StateLoadingToCarrier(
        selectedCarrier: selectedCarrier ?? this.selectedCarrier,
        unitsToLoad: unitsToLoad ?? this.unitsToLoad,
        landingPoint: landingPoint ?? this.landingPoint,
      );
}

class _StateTransporting extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  _StateTransporting({
    required this.selectedCarrier,
    required this.landingPoint,
  });
}

class _StateLanding extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  _StateLanding({
    required this.selectedCarrier,
    required this.landingPoint,
  });
}

class _StateMoveUnitsAfterLanding extends _TroopTransferState {
  final Carrier selectedCarrier;
  
  final Iterable<Unit> landedUnits;

  _StateMoveUnitsAfterLanding({required this.selectedCarrier, required this.landedUnits});
}

class _StateCompleted extends _TroopTransferState {}
