part of carriers_phase_library;

class _TransitionResult {
  final _TroopTransferState newState;

  final bool canContinue;

  _TransitionResult({required this.newState, required this.canContinue});

  _TransitionResult.completed()
      : newState = _StateCompleted(),
        canContinue = false;
}

abstract interface class _TroopTransferTransition {
  Future<_TransitionResult> process();
}
