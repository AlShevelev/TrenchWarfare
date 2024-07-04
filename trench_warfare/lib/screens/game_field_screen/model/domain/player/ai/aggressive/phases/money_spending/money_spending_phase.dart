part of aggressive_player_ai;

class MoneySpendingPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  MoneySpendingPhase(
    this._player,
    this._gameField,
    this._myNation,
    this._nationMoney,
    this._metadata,
  );

  Future<void> start() async {
    while (true) {
      final influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation()..calculate(data), _gameField);
    }
  }

  Iterable<EstimationResult<ProductionCenterEstimationData>> _estimateProductionCentersInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<EstimationResult<ProductionCenterEstimationData>> result = [];

    final types = [
      ProductionCenterType.navalBase,
      ProductionCenterType.city,
      ProductionCenterType.factory,
      ProductionCenterType.airField
    ];

    for (final type in types) {
      final estimator = ProductionCenterEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        type: type,
        influenceMap: influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }

  Iterable<EstimationResult<UnitEstimationData>> _estimateUnitsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<EstimationResult<UnitEstimationData>> result = [];

    final types = [
      UnitType.armoredCar,
      UnitType.artillery,
      UnitType.infantry,
      UnitType.cavalry,
      UnitType.machineGunnersCart,
      UnitType.machineGuns,
      UnitType.tank,
      UnitType.destroyer,
      UnitType.cruiser,
      UnitType.battleship,
    ];

    for (final type in types) {
      final estimator = UnitsEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        type: type,
        influenceMap: influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }
}


// refactoring - divide on phases