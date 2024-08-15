part of carriers_phase_library;

abstract interface class TroopTransferRead {
  String get id;

  bool get isCompleted;

  String? get selectedCarrierId;

  LandingPoint? get landingPoint;

  LandingPoint? get gatheringPoint;

  List<UnitOnCell> get gatheringUnits;
}

class _TroopTransfer implements TroopTransferRead {
  final GameFieldCellRead _targetCell;

  final ActiveCarrierTroopTransfersRead _allTransfers;

  final GameFieldRead _gameField;

  final Nation _myNation;

  _TroopTransferState _currentState = _TroopTransferStateInit();

  final String _id;
  @override
  String get id => _id;

  _CarrierOnCell? _selectedCarrier;
  @override
  String? get selectedCarrierId => _selectedCarrier?.carrier.id;

  @override
  bool get isCompleted => _currentState is _TroopTransferStateCompleted;

  LandingPoint? _landingPoint;
  @override
  LandingPoint? get landingPoint => _landingPoint;

  LandingPoint? _gatheringPoint;
  @override
  LandingPoint? get gatheringPoint => _gatheringPoint;

  List<UnitOnCell> _gatheringUnits = [];
  @override
  List<UnitOnCell> get gatheringUnits => _gatheringUnits;

  _TroopTransfer({
    required GameFieldCellRead targetCell,
    required ActiveCarrierTroopTransfersRead allTransfers,
    required GameFieldRead gameField,
    required Nation myNation,
  })  : _targetCell = targetCell,
        _allTransfers = allTransfers,
        _gameField = gameField,
        _myNation = myNation,
        _id = RandomGen.generateId();

  Future<void> process() async {
    if (!_isGoalReachable()) {
      _currentState = _TroopTransferStateCompleted();
    } else {
      _TransitionResult transitionResult;

      do {
        var transition = _getTransition();
        transitionResult = await transition.process();

        _currentState = transitionResult.newState;
        _processTransitionResult(transitionResult);
      } while (!transitionResult.processed);
    }

    if (_currentState is _TroopTransferStateCompleted) {
      _cleanUp();
    }
  }

  bool _isGoalReachable() {
    if (_currentState is _TroopTransferStateInit || _currentState is _TroopTransferStateCompleted) {
      return true;
    }

    throw UnimplementedError();
  }

  _TroopTransferTransition _getTransition() => switch (_currentState) {
        _TroopTransferStateInit() => _InitTransition(
            targetCell: _targetCell,
            gameField: _gameField,
            myNation: _myNation,
            allTransfers: _allTransfers,
            myTransferId: _id,
          ),
        _TroopTransferStateGathering() => _GatheringTransition(),
        _TroopTransferStateTransporting() => _TransportingTransition(),
        _TroopTransferStateLanding() => _LandingTransition(),
        _TroopTransferStateMovementAfterLanding() => _MovementAfterLadingTransition(),
        _TroopTransferStateCompleted() => throw UnsupportedError('This state is not supported'),
      };

  void _processTransitionResult(_TransitionResult transitionResult) {
    if (transitionResult is _TransitionResultPayload) {
      final payload = transitionResult.payload;

      switch (payload) {
        case _InitTransitionResult(
            selectedCarrier: final selectedCarrier,
            landingPoint: final landingPoint,
            gatheringPointAndUnits: final gatheringPointAndUnits,
          ):
          {
            _selectedCarrier = selectedCarrier;
            _landingPoint = landingPoint;
            _gatheringPoint = gatheringPointAndUnits?.gatheringPoint;
            _gatheringUnits = gatheringPointAndUnits?.units ?? [];
            break;
          }
      }
    }
  }

  void _cleanUp() {
    // clear state etc.
    throw UnimplementedError();
  }
}
