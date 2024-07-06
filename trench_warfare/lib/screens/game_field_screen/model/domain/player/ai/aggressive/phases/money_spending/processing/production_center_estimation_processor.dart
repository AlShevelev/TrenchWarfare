part of aggressive_player_ai;

class ProductionCenterEstimationProcessor extends EstimationProcessorBase<ProductionCenterEstimationData> {
  ProductionCenterEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<ProductionCenterEstimationData>> _makeEstimations() {
    final List<EstimationResult<ProductionCenterEstimationData>> result = [];

    final types = [
      ProductionCenterType.navalBase,
      ProductionCenterType.city,
      ProductionCenterType.factory,
      ProductionCenterType.airField,
    ];

    for (final type in types) {
      final estimator = ProductionCenterEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        type: type,
        influenceMap: _influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<ProductionCenterEstimationData> estimationItem) =>
      GameFieldControlsProductionCentersCardBrief(type: estimationItem.data.type);
}
