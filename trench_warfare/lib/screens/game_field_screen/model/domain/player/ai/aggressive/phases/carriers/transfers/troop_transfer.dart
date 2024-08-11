part of aggressive_player_ai;

abstract interface class TroopTransferRead {
  String get id;

  bool get isCompleted;

  String? get selectedCarrierId;
}

class TroopTransfer implements TroopTransferRead {
  final GameFieldCellRead _targetCell;

  final ActiveCarrierTroopTransfersRead _allTransfers;

  final GameFieldRead _gameField;

  final Nation _myNation;

  TroopTransferState _currentState = TroopTransferStateInit();

  final String _id;
  @override
  String get id => _id;

  _CarrierOnCell? _selectedCarrier;
  @override
  String? get selectedCarrierId => _selectedCarrier?.carrier.id;

  @override
  bool get isCompleted => _currentState is TroopTransferStateCompleted;

  TroopTransfer({
    required GameFieldCellRead targetCell,
    required ActiveCarrierTroopTransfersRead allTransfers,
    required GameFieldRead gameField,
    required  Nation myNation,
  })  : _targetCell = targetCell,
        _allTransfers = allTransfers,
        _gameField = gameField,
        _myNation = myNation,
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
        _processTransitionResult(transitionResult);
      } while (!transitionResult.processed);
    }

    if (_currentState is TroopTransferStateCompleted) {
      _cleanUp();
    }
  }

  bool _isGoalReachable() {
    if (_currentState is TroopTransferStateInit || _currentState is TroopTransferStateCompleted) {
      return true;
    }

    throw UnimplementedError();
  }

  TroopTransferTransition _getTransition() => switch (_currentState) {
        TroopTransferStateInit() => TroopTransferInitTransition(
            targetCell: _targetCell,
            gameField: _gameField,
            myNation: _myNation,
            allTransfers: _allTransfers,
            myTransferId: _id,
          ),
        TroopTransferStateGathering() => TroopTransferGatheringTransition(),
        TroopTransferStateTransporting() => TroopTransferTransportingTransition(),
        TroopTransferStateLanding() => TroopTransferLandingTransition(),
        TroopTransferStateMovementAfterLanding() => TroopTransferMovementAfterLadingTransition(),
        TroopTransferStateCompleted() => throw UnsupportedError('This state is not supported'),
      };

  void _processTransitionResult(TroopTransferTransitionResult transitionResult) {
    throw UnimplementedError();
  }

  void _cleanUp() {
    // clear state etc.
    throw UnimplementedError();
  }
}
