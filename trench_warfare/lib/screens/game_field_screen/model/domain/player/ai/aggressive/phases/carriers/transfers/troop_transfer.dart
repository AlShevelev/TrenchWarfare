part of aggressive_player_ai;

class TroopTransfer {
  final GameFieldCellRead _targetCell;

  final ActiveCarrierTroopTransfersRequests _otherTransferRequests;

  TroopTransferState _currentState = TroopTransferStateInit();

  final String _id;
  String get id => _id;

  bool get isCompleted => _currentState is TroopTransferStateCompleted;

  TroopTransfer({
    required GameFieldCellRead targetCell,
    required ActiveCarrierTroopTransfersRequests otherTransferRequests,
  })  : _targetCell = targetCell,
        _otherTransferRequests = otherTransferRequests,
        _id = RandomGen.generateId();

  Future<void> process() async {
    if (!_isGoalReachable()) {
      _currentState = TroopTransferStateCompleted();
    } else {
      TroopTransferTransitionResult transitionResult;

      do {
        var transition = _getTransition();

        transitionResult = await transition.process();

        _currentState = transitionResult.newState;
      } while (!transitionResult.processed);
    }

    if (_currentState is TroopTransferStateCompleted) {
      _cleanUp();
    }
  }

  TroopTransferTransition _getTransition() {
    throw UnimplementedError(); init transition must be first
  }

  bool _isGoalReachable() {
    if (_currentState is TroopTransferStateInit || _currentState is TroopTransferStateCompleted) {
      return true;
    }

    throw UnimplementedError();
  }

  void _cleanUp() {
    // clear state etc.
    throw UnimplementedError();
  }
}
