part of money_spending_phase_library;

class _ProductionCenterEstimationProcessor extends _EstimationProcessorBase<_ProductionCenterEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  _ProductionCenterEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<_ProductionCenterEstimationData>> _makeEstimations() {
    final List<EstimationResult<_ProductionCenterEstimationData>> result = [];

    final types = [
      ProductionCenterType.navalBase,
      ProductionCenterType.city,
      ProductionCenterType.factory,
      ProductionCenterType.airField,
    ];

    for (final type in types) {
      final estimator = _ProductionCenterEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.totalSum,
        type: type,
        influenceMap: _influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_ProductionCenterEstimationData> estimationItem) =>
      GameFieldControlsProductionCentersCardBrief(type: estimationItem.data.type);
}
