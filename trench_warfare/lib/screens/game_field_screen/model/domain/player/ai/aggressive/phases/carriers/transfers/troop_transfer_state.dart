part of carriers_phase_library;

sealed class _TroopTransferState {}

class _TroopTransferStateInit extends _TroopTransferState {}

class _TroopTransferStateGathering extends _TroopTransferState {
  final _CarrierOnCell selectedCarrier;

  final LandingPoint landingPoint;

  final _GatheringPointAndUnits gatheringPointAndUnits;

  _TroopTransferStateGathering({
    required this.selectedCarrier,
    required this.landingPoint,
    required this.gatheringPointAndUnits,
  });
}

class _TroopTransferStateTransporting extends _TroopTransferState {
  final _CarrierOnCell selectedCarrier;

  final LandingPoint landingPoint;

  _TroopTransferStateTransporting({
    required this.selectedCarrier,
    required this.landingPoint,
  });
}

class _TroopTransferStateLanding extends _TroopTransferState {}

class _TroopTransferStateMovementAfterLanding extends _TroopTransferState {}

class _TroopTransferStateCompleted extends _TroopTransferState {}
