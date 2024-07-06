part of aggressive_player_ai;

class UnitBoosterEstimationProcessor extends EstimationProcessorBase<UnitBoosterEstimationData> {
  UnitBoosterEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<UnitBoosterEstimationData>> _makeEstimations() {
    final List<EstimationResult<UnitBoosterEstimationData>> result = [];

    result.addAll(
      AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.attack,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.defence,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      CommanderEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      TransportEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
      ).estimate(),
    );

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<UnitBoosterEstimationData> estimationItem) =>
      GameFieldControlsUnitBoostersCardBrief(type: estimationItem.data.type);
}
