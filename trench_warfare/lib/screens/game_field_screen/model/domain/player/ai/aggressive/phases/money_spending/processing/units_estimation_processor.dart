part of money_spending_phase_library;

class _UnitsEstimationProcessor extends _EstimationProcessorBase<_UnitsBuildingEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.5;

  _UnitsEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<_UnitsBuildingEstimationData>> _makeEstimations() {
    final List<EstimationResult<_UnitsBuildingEstimationData>> result = [];

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
      final estimator = _UnitsBuildingEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney,
          influenceMap: _influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_UnitsBuildingEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: estimationItem.data.type);
}
