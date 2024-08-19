part of carriers_phase_library;

sealed class _TroopTransferState {}

class _StateInit extends _TroopTransferState {}

class _StateGathering extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  final LandingPoint gatheringPoint;

  final List<Unit> gatheringUnits;

  _StateGathering({
    required this.selectedCarrier,
    required this.landingPoint,
    required this.gatheringPoint,
    required this.gatheringUnits,
  });

  _StateGathering copy({
    Carrier? selectedCarrier,
    LandingPoint? landingPoint,
    LandingPoint? gatheringPoint,
    List<Unit>? gatheringUnits,
  }) =>
      _StateGathering(
        selectedCarrier: selectedCarrier ?? this.selectedCarrier,
        landingPoint: landingPoint ?? this.landingPoint,
        gatheringPoint: gatheringPoint ?? this.gatheringPoint,
        gatheringUnits: gatheringUnits ?? this.gatheringUnits,
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

class _StateMovementAfterLanding extends _TroopTransferState {}

class _StateCompleted extends _TroopTransferState {}
