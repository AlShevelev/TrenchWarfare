/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of carriers_phase_library;

abstract interface class TroopTransferRead {
  String get id;

  bool get isCompleted;

  String? get selectedCarrierId;

  LandingPoint? get landingPoint;

  LandingPoint? get gatheringPoint;

  List<Unit> get transportingUnits;
}

abstract interface class TroopTransferReadForSaving {
  String get id;

  String? get selectedCarrierId;

  LandingPoint? get landingPoint;

  LandingPoint? get gatheringPoint;

  List<Unit> get transportingUnits;

  GameFieldCellRead get targetCell;

  String get stateAlias;
}

class _TroopTransfer implements TroopTransferRead, TroopTransferReadForSaving {
  final GameFieldCellRead _targetCell;

  @override
  GameFieldCellRead get targetCell => _targetCell;

  final CarrierTroopTransfersStorageRead _transfersStorage;

  final GameFieldRead _gameField;

  final Nation _myNation;

  late PlayerActions _actions;

  final MapMetadataRead _metadata;

  late _TroopTransferState _currentState;

  @override
  String get stateAlias => _currentState.stateAlias;

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
        _id = RandomGen.generateId(),
        _currentState = _StateInit();

  _TroopTransfer.fromSaving({
    required TroopTransferReadForSaving saving,
    required CarrierTroopTransfersStorageRead transfersStorage,
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _targetCell = saving.targetCell,
        _transfersStorage = transfersStorage,
        _gameField = gameField,
        _myNation = myNation,
        _id = saving.id,
        _metadata = metadata {
    _currentState = switch (saving.stateAlias) {
      _StateInit._stateAlias => _StateInit(),
      _StateGathering._stateAlias => _StateGathering(
          selectedCarrier: _gameField.findUnitById(saving.selectedCarrierId!, _myNation) as Carrier,
          landingPoint: saving.landingPoint!,
          gatheringPoint: saving.gatheringPoint!,
          gatheringUnits: saving.transportingUnits
              .where((u) => u.id != saving.selectedCarrierId!)
              .toList(growable: false),
          transferTargetCell: saving.targetCell,
        ),
      _StateLoadingToCarrier._stateAlias => _StateLoadingToCarrier(
          selectedCarrier: _gameField.findUnitById(saving.selectedCarrierId!, _myNation) as Carrier,
          landingPoint: saving.landingPoint!,
          unitsToLoad: saving.transportingUnits
              .where((u) => u.id != saving.selectedCarrierId!)
              .toList(growable: false),
        ),
      _StateTransporting._stateAlias => _StateTransporting(
          selectedCarrier: _gameField.findUnitById(saving.selectedCarrierId!, _myNation) as Carrier,
          landingPoint: saving.landingPoint!,
        ),
      _StateLanding._stateAlias => _StateLanding(
          selectedCarrier: _gameField.findUnitById(saving.selectedCarrierId!, _myNation) as Carrier,
          landingPoint: saving.landingPoint!,
        ),
      _StateMoveUnitsAfterLanding._stateAlias => _StateMoveUnitsAfterLanding(
          selectedCarrier: _gameField.findUnitById(saving.selectedCarrierId!, _myNation) as Carrier,
          landedUnits: saving.transportingUnits
              .where((u) => u.id != saving.selectedCarrierId!)
              .toList(growable: false),
        ),
      _StateCompleted._stateAlias => _StateCompleted(),
      _ => throw UnsupportedError('This state is not supported: ${saving.stateAlias}'),
    };
  }

  void setPlayerActions(PlayerActions actions) {
    _actions = actions;
  }

  Future<void> process() async {
    Logger.info('Transfer [$id] processing started', tag: 'CARRIER');

    var canContinue = true;
    Logger.info('Start state: ${_currentState.stateAlias}', tag: 'CARRIER');
    _currentState.logState();
    while (_currentState is! _StateCompleted && canContinue) {
      var transition = _getTransition();

      final transitionResult = await transition.process();

      _currentState = transitionResult.newState;
      canContinue = transitionResult.canContinue;
      Logger.info('New state: ${_currentState.stateAlias}; canContinue: $canContinue', tag: 'CARRIER');
      _currentState.logState();
    }

    Logger.info('End state: ${_currentState.stateAlias};', tag: 'CARRIER');
    _currentState.logState();

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
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
          ),
        _StateGathering() => _GatheringTransition(
            state: _currentState as _StateGathering,
            actions: _actions,
            myNation: _myNation,
            gameField: _gameField,
            myTransferId: _id,
            transfersStorage: _transfersStorage,
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
          ),
        _StateLoadingToCarrier() => _LoadingToCarrierTransition(
            state: _currentState as _StateLoadingToCarrier,
            actions: _actions,
            myNation: _myNation,
            gameField: _gameField,
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
          ),
        _StateTransporting() => _TransportingTransition(
            state: _currentState as _StateTransporting,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
          ),
        _StateLanding() => _LandingTransition(
            state: _currentState as _StateLanding,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
          ),
        _StateMoveUnitsAfterLanding() => _MovementAfterLadingTransition(
            state: _currentState as _StateMoveUnitsAfterLanding,
            actions: _actions,
            gameField: _gameField,
            myNation: _myNation,
            metadata: _metadata,
            pathFacade: PathFacade(_gameField, _myNation, _metadata),
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
