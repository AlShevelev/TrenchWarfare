part of money_spending_phase_library;

class _UnitBoosterEstimationProcessor extends _EstimationProcessorBase<_UnitBoosterEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  _UnitBoosterEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<_UnitBoosterEstimationData>> _makeEstimations() {
    final List<EstimationResult<_UnitBoosterEstimationData>> result = [];

    result.addAll(
      _AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.attack,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.defence,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _CommanderEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _TransportEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
      ).estimate(),
    );

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_UnitBoosterEstimationData> estimationItem) =>
      GameFieldControlsUnitBoostersCardBrief(type: estimationItem.data.type);
}
