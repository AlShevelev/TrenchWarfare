part of aggressive_player_ai;

class TroopTransferTransitionResult {
  final bool processed;

  final TroopTransferState newState;

  TroopTransferTransitionResult({
    required this.processed,
    required this.newState,
  });
}

class TroopTransferTransitionResultPayload<T> extends TroopTransferTransitionResult {
  final T payload;

  TroopTransferTransitionResultPayload({
    required super.processed,
    required super.newState,
    required this.payload,
  });
}

abstract interface class TroopTransferTransition {
  Future<TroopTransferTransitionResult> process();
}
