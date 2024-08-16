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

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final GameFieldRead _gameField;

  final Nation _myNation;

  _TroopTransferState _currentState = _TroopTransferStateInit();

  final String _id;
  @override
  String get id => _id;

  @override
  String? get selectedCarrierId => _getSelectedCarrierId();

  @override
  bool get isCompleted => _currentState is _TroopTransferStateCompleted;

  @override
  LandingPoint? get landingPoint => _getLandingPoint();

  @override
  LandingPoint? get gatheringPoint => _getGatheringPoint();

  @override
  List<UnitOnCell> get gatheringUnits => _getGatheringUnits();

  _TroopTransfer({
    required GameFieldCellRead targetCell,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required GameFieldRead gameField,
    required Nation myNation,
  })  : _targetCell = targetCell,
        _transfersStorage = transfersStorage,
        _gameField = gameField,
        _myNation = myNation,
        _id = RandomGen.generateId();

  Future<void> process() async {
    if (!_isGoalReachable()) {
      _currentState = _TroopTransferStateCompleted();
    } else {
      var transition = _getTransition();
      _currentState = await transition.process();
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
            transfersStorage: _transfersStorage,
            myTransferId: _id,
          ),
        _TroopTransferStateGathering() => _GatheringTransition(
            state: _currentState as _TroopTransferStateGathering,
          ),
        _TroopTransferStateTransporting() => _TransportingTransition(
            state: _currentState as _TroopTransferStateTransporting,
          ),
        _TroopTransferStateLanding() => _LandingTransition(
            state: _currentState as _TroopTransferStateLanding,
          ),
        _TroopTransferStateMovementAfterLanding() => _MovementAfterLadingTransition(
            state: _currentState as _TroopTransferStateMovementAfterLanding,
          ),
        _TroopTransferStateCompleted() => throw UnsupportedError('This state is not supported'),
      };

  String? _getSelectedCarrierId() {
    final currentState = _currentState;

    return switch (currentState) {
      _TroopTransferStateInit() => null,
      _TroopTransferStateGathering() => currentState.selectedCarrier.carrier.id,
      _TroopTransferStateTransporting() => currentState.selectedCarrier.carrier.id,
      _TroopTransferStateLanding() => null,
      _TroopTransferStateMovementAfterLanding() => null,
      _TroopTransferStateCompleted() => null,
    };
  }

  LandingPoint? _getLandingPoint() {
    final currentState = _currentState;

    return switch (currentState) {
      _TroopTransferStateInit() => null,
      _TroopTransferStateGathering() => currentState.landingPoint,
      _TroopTransferStateTransporting() => currentState.landingPoint,
      _TroopTransferStateLanding() => null,
      _TroopTransferStateMovementAfterLanding() => null,
      _TroopTransferStateCompleted() => null,
    };
  }

  LandingPoint? _getGatheringPoint() {
    final currentState = _currentState;

    return switch (currentState) {
      _TroopTransferStateInit() => null,
      _TroopTransferStateGathering() => currentState.gatheringPointAndUnits.gatheringPoint,
      _TroopTransferStateTransporting() => null,
      _TroopTransferStateLanding() => null,
      _TroopTransferStateMovementAfterLanding() => null,
      _TroopTransferStateCompleted() => null,
    };
  }

  List<UnitOnCell> _getGatheringUnits() {
    final currentState = _currentState;

    return switch (currentState) {
      _TroopTransferStateInit() => [],
      _TroopTransferStateGathering() => currentState.gatheringPointAndUnits.units,
      _TroopTransferStateTransporting() => [],
      _TroopTransferStateLanding() => [],
      _TroopTransferStateMovementAfterLanding() => [],
      _TroopTransferStateCompleted() => [],
    };
  }

  void _cleanUp() {
    // clear state etc.
    throw UnimplementedError();
  }
}
