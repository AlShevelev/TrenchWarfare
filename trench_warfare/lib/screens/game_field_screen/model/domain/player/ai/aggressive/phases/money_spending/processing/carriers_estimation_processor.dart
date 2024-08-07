part of aggressive_player_ai;

class CarriersEstimationProcessor extends EstimationProcessorBase<CarriersBuildingEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.5;

  CarriersEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<CarriersBuildingEstimationData>> _makeEstimations() => CarriersBuildingEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        metadata: _metadata,
      ).estimate();

  @override
  GameFieldControlsCard _toCard(EstimationResult<CarriersBuildingEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: UnitType.carrier);
}
