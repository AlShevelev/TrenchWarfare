part of carriers_phase_library;

sealed class _TroopTransferState { }

class _TroopTransferStateInit extends _TroopTransferState { }

class _TroopTransferStateGathering extends _TroopTransferState { }

class _TroopTransferStateTransporting extends _TroopTransferState { }

class _TroopTransferStateLanding extends _TroopTransferState { }

class _TroopTransferStateMovementAfterLanding extends _TroopTransferState { }

class _TroopTransferStateCompleted extends _TroopTransferState { }
