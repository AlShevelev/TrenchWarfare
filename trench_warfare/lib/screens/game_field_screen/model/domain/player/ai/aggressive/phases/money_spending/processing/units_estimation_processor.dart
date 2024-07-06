part of aggressive_player_ai;

class UnitsEstimationProcessor extends EstimationProcessorBase<UnitEstimationData> {
  UnitsEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<UnitEstimationData>> _makeEstimations() {
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
      UnitType.battleship
    ];

    for (final type in types) {
      final estimator = UnitsEstimator(
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
  GameFieldControlsCard _toCard(EstimationResult<UnitEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: estimationItem.data.type);
}
