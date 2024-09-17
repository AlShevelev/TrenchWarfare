part of carriers_phase_library;

abstract interface class TroopTransferRead {
  String get id;

  bool get isCompleted;

  String? get selectedCarrierId;

  LandingPoint? get landingPoint;

  LandingPoint? get gatheringPoint;

  List<Unit> get transportingUnits;
}

class _TroopTransfer implements TroopTransferRead {
  final GameFieldCellRead _targetCell;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final GameFieldRead _gameField;

  final Nation _myNation;

  late PlayerActions _actions;

  final MapMetadataRead _metadata;

  _TroopTransferState _currentState = _StateInit();

  final String _id;
  @override
  String get id => _id;

  @override
  String? get selectedCarrierId => _getSelectedCarrierId();

  @override
  bool get isCompleted => _currentState is _StateCompleted;

  @override
  LandingPoint? get landingPoint => _getLandingPoint();

  @override
  LandingPoint? get gatheringPoint => _getGatheringPoint();

  @override
  List<Unit> get transportingUnits => _getTransportingUnits();

  _TroopTransfer({
    required GameFieldCellRead targetCell,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required GameFieldRead gameField,
    required Nation myNation,
    required PlayerActions actions,
    required MapMetadataRead metadata,
  })  : _targetCell = targetCell,
        _transfersStorage = transfersStorage,
        _gameField = gameField,
        _myNation = myNation,
        _actions = actions,
        _metadata = metadata,
        _id = RandomGen.generateId();

  void setPlayerActions(PlayerActions actions) {
    _actions = actions;
  }

  Future<void> process() async {
    var canContinue = true;
    print('CARRIER [${this.hashCode}]----------------------- ');
    print('CARRIER start state: $_currentState');
    while (_currentState is! _StateCompleted && canContinue) {
      var transition = _getTransition();

      final transitionResult = await transition.process();

      _currentState = transitionResult.newState;
      canContinue = transitionResult.canContinue;
      print('CARRIER new state: $_currentState; canContinue: $canContinue');
    }

    print('CARRIER end state: $_currentState');

    if (_currentState is _StateCompleted) {
      _cleanUp();
    }
  }

  _TroopTransferTransition _getTransition() => switch (_currentState) {
        _StateInit() => _InitTransition(
            transferTargetCell: _targetCell,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
            transfersStorage: _transfersStorage,
            myTransferId: _id,
          ),
        _StateGathering() => _GatheringTransition(
            state: _currentState as _StateGathering,
            actions: _actions,
            myNation: _myNation,
            gameField: _gameField,
            myTransferId: _id,
            transfersStorage: _transfersStorage,
          ),
        _StateLoadingToCarrier() => _LoadingToCarrierTransition(
          state: _currentState as _StateLoadingToCarrier,
          actions: _actions,
          myNation: _myNation,
          gameField: _gameField,
        ),
        _StateTransporting() => _TransportingTransition(
            state: _currentState as _StateTransporting,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
          ),
        _StateLanding() => _LandingTransition(
            state: _currentState as _StateLanding,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
          ),
          _StateMoveUnitsAfterLanding() => _MovementAfterLadingTransition(
            state: _currentState as _StateMoveUnitsAfterLanding,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
            metadata: _metadata,
          ),
        _StateCompleted() => throw UnsupportedError('This state is not supported'),
      };

  String? _getSelectedCarrierId() {
    final currentState = _currentState;

    return switch (currentState) {
      _StateInit() => null,
      _StateGathering() => currentState.selectedCarrier.id,
      _StateLoadingToCarrier() => currentState.selectedCarrier.id,
      _StateTransporting() => currentState.selectedCarrier.id,
      _StateLanding() => currentState.selectedCarrier.id,
      _StateMoveUnitsAfterLanding() => currentState.selectedCarrier.id,
      _StateCompleted() => null,
    };
  }

  LandingPoint? _getLandingPoint() {
    final currentState = _currentState;

    return switch (currentState) {
      _StateInit() => null,
      _StateGathering() => currentState.landingPoint,
      _StateLoadingToCarrier() => currentState.landingPoint,
      _StateTransporting() => currentState.landingPoint,
      _StateLanding() => currentState.landingPoint,
      _StateMoveUnitsAfterLanding() => null,
      _StateCompleted() => null,
    };
  }

  LandingPoint? _getGatheringPoint() {
    final currentState = _currentState;

    return switch (currentState) {
      _StateInit() => null,
      _StateGathering() => currentState.gatheringPoint,
      _StateLoadingToCarrier() => null,
      _StateTransporting() => null,
      _StateLanding() => null,
      _StateMoveUnitsAfterLanding() => null,
      _StateCompleted() => null,
    };
  }

  List<Unit> _getTransportingUnits() {
    final currentState = _currentState;

    return switch (currentState) {
      _StateInit() => [],
      _StateGathering() => <Unit>[...currentState.gatheringUnits, currentState.selectedCarrier],
      _StateLoadingToCarrier() => <Unit>[...currentState.unitsToLoad, currentState.selectedCarrier],
      _StateTransporting() => <Unit>[currentState.selectedCarrier],
      _StateLanding() => <Unit>[currentState.selectedCarrier],
      _StateMoveUnitsAfterLanding() => <Unit>[...currentState.landedUnits, currentState.selectedCarrier],
      _StateCompleted() => [],
    };
  }

  void _cleanUp() {
    // clear state etc. - do nothing so far
  }
}
