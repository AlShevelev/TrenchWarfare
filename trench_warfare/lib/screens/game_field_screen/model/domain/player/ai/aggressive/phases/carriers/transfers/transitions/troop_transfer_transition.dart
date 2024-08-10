part of aggressive_player_ai;

class TroopTransferTransitionResult {
  final bool processed;

  final TroopTransferState newState;

  TroopTransferTransitionResult({
    required this.processed,
    required this.newState,
  });
}

abstract interface class TroopTransferTransition {
  Future<TroopTransferTransitionResult> process();
}