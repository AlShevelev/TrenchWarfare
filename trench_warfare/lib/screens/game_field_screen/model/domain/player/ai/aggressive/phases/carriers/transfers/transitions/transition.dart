part of carriers_phase_library;

class _TransitionResult {
  final bool processed;

  final _TroopTransferState newState;

  _TransitionResult({
    required this.processed,
    required this.newState,
  });

  _TransitionResult.completed():
      processed = true,
      newState = _TroopTransferStateCompleted();
}

class _TransitionResultPayload<T> extends _TransitionResult {
  final T payload;

  _TransitionResultPayload({
    required super.processed,
    required super.newState,
    required this.payload,
  });
}

abstract interface class _TroopTransferTransition {
  Future<_TransitionResult> process();
}
