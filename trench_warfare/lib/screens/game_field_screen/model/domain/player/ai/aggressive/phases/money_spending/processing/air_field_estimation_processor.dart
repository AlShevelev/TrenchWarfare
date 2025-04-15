part of money_spending_phase_library;

class _AirFieldEstimationProcessor extends _EstimationProcessorBase<_AirFieldEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  _AirFieldEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
    required super.unitUpdateResultBridge,
  });

  @override
  Iterable<EstimationResult<_AirFieldEstimationData>> _makeEstimations() =>
    _AirFieldEstimator(
      gameField: _gameField,
      myNation: _myNation,
      nationMoney: _nationMoney,
      influenceMap: _influenceMap,
      metadata: _metadata,
    ).estimate();

  @override
  GameFieldControlsCard _toCard(EstimationResult<_AirFieldEstimationData> estimationItem) =>
      GameFieldControlsProductionCentersCardBrief(type: ProductionCenterType.airField);
}
