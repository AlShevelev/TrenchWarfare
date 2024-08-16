part of carriers_phase_library;

abstract interface class _TroopTransferTransition {
  Future<_TroopTransferState> process();
}
