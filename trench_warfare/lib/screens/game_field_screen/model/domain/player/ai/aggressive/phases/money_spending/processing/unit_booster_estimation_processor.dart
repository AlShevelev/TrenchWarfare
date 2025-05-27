/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
    required super.unitUpdateResultBridge,
  });

  @override
  Iterable<EstimationResult<_UnitBoosterEstimationData>> _makeEstimations() {
    final List<EstimationResult<_UnitBoosterEstimationData>> result = [];

    result.addAll(
      _AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.attack,
        nationMoney: _nationMoney.totalSum,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _AttackDefenceEstimator(
        gameField: _gameField,
        myNation: _myNation,
        type: UnitBoost.defence,
        nationMoney: _nationMoney.totalSum,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _CommanderEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.totalSum,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _TransportEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.totalSum,
      ).estimate(),
    );

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_UnitBoosterEstimationData> estimationItem) =>
      GameFieldControlsUnitBoostersCardBrief(type: estimationItem.data.type);
}
