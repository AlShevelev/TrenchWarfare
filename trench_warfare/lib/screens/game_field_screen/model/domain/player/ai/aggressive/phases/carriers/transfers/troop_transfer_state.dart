part of carriers_phase_library;

sealed class _TroopTransferState {
  void logState();

  String get stateAlias;
}

class _StateInit extends _TroopTransferState {
  static const _stateAlias = 'INIT';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias [End log]');
  }
}

class _StateGathering extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  final LandingPoint gatheringPoint;

  final List<Unit> gatheringUnits;

  final GameFieldCellRead transferTargetCell;

  _StateGathering({
    required this.selectedCarrier,
    required this.landingPoint,
    required this.gatheringPoint,
    required this.gatheringUnits,
    required this.transferTargetCell,
  });

  _StateGathering copy({
    Carrier? selectedCarrier,
    LandingPoint? landingPoint,
    LandingPoint? gatheringPoint,
    List<Unit>? gatheringUnits,
    GameFieldCellRead? transferTargetCell,
  }) =>
      _StateGathering(
        selectedCarrier: selectedCarrier ?? this.selectedCarrier,
        landingPoint: landingPoint ?? this.landingPoint,
        gatheringPoint: gatheringPoint ?? this.gatheringPoint,
        gatheringUnits: gatheringUnits ?? this.gatheringUnits,
        transferTargetCell: transferTargetCell ?? this.transferTargetCell,
      );

  static const _stateAlias = 'GATHERING';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias');
    Logger.info('Carrier: $selectedCarrier');
    Logger.info('Landing: $landingPoint');
    Logger.info('Gathering: $gatheringPoint');
    Logger.info('Target cell: $transferTargetCell');
    Logger.info('Gathering units:');
    for (var i = 0; i < gatheringUnits.length; i++) {
      Logger.info('[$i] Unit: ${gatheringUnits[i]}');
    }
    Logger.info('[End log] $_stateAlias');
  }
}

class _StateLoadingToCarrier extends _TroopTransferState {
  final Carrier selectedCarrier;

  final List<Unit> unitsToLoad;

  final LandingPoint landingPoint;

  _StateLoadingToCarrier({
    required this.selectedCarrier,
    required this.unitsToLoad,
    required this.landingPoint,
  });

  _StateLoadingToCarrier copy({
    Carrier? selectedCarrier,
    List<Unit>? unitsToLoad,
    LandingPoint? landingPoint,
  }) =>
      _StateLoadingToCarrier(
        selectedCarrier: selectedCarrier ?? this.selectedCarrier,
        unitsToLoad: unitsToLoad ?? this.unitsToLoad,
        landingPoint: landingPoint ?? this.landingPoint,
      );

  static const _stateAlias = 'LOADING_TO_CARRIER';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias');
    Logger.info('Carrier: $selectedCarrier');
    Logger.info('Landing: $landingPoint');
    Logger.info('Loading units:');
    for (var i = 0; i < unitsToLoad.length; i++) {
      Logger.info('[$i] Unit: ${unitsToLoad[i]}');
    }
    Logger.info('[End log] $_stateAlias');

  }
}

class _StateTransporting extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  _StateTransporting({
    required this.selectedCarrier,
    required this.landingPoint,
  });

  static const _stateAlias = 'TRANSPORTING';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias');
    Logger.info('Carrier: $selectedCarrier');
    Logger.info('Landing: $landingPoint');
    Logger.info('[End log] $_stateAlias');
  }
}

class _StateLanding extends _TroopTransferState {
  final Carrier selectedCarrier;

  final LandingPoint landingPoint;

  _StateLanding({
    required this.selectedCarrier,
    required this.landingPoint,
  });

  static const _stateAlias = 'LANDING';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias');
    Logger.info('Carrier: $selectedCarrier');
    Logger.info('Landing: $landingPoint');
    Logger.info('[End log] $_stateAlias');
  }
}

class _StateMoveUnitsAfterLanding extends _TroopTransferState {
  final Carrier selectedCarrier;
  
  final Iterable<Unit> landedUnits;

  _StateMoveUnitsAfterLanding({required this.selectedCarrier, required this.landedUnits});

  static const _stateAlias = 'MOVE_UNITS_AFTER_LANDING';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias');
    Logger.info('Carrier: $selectedCarrier');
    Logger.info('Landed units:');
    for (var i = 0; i < landedUnits.length; i++) {
      Logger.info('[$i] Unit: ${landedUnits.elementAt(i)}');
    }
    Logger.info('[End log] $_stateAlias');
  }
}

class _StateCompleted extends _TroopTransferState {
  static const _stateAlias = 'COMPLETED';
  @override
  String get stateAlias => _stateAlias;

  @override
  void logState() {
    Logger.info('[Start log] $_stateAlias [End log]');
  }
}
