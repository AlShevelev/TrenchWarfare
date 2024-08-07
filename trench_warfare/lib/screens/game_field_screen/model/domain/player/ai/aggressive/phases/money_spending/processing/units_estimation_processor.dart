part of aggressive_player_ai;

class UnitsEstimationProcessor extends EstimationProcessorBase<UnitsBuildingEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.5;

  UnitsEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<UnitsBuildingEstimationData>> _makeEstimations() {
    final List<EstimationResult<UnitsBuildingEstimationData>> result = [];

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
      UnitType.battleship
    ];

    for (final type in types) {
      final estimator = UnitsBuildingEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney.actual,
          influenceMap: _influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<UnitsBuildingEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: estimationItem.data.type);
}
