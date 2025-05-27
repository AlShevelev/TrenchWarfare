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

class _SpecialStrikeEstimationProcessor extends _EstimationProcessorBase<_SpecialStrikeEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  _SpecialStrikeEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
    required super.unitUpdateResultBridge,
  });

  @override
  Iterable<EstimationResult<_SpecialStrikeEstimationData>> _makeEstimations() {
    final List<EstimationResult<_SpecialStrikeEstimationData>> result = [];

    result.addAll(
      _AirBombardmentEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        metadata: _metadata,
        influenceMap: _influenceMap,
      ).estimate(),
    );

    result.addAll(
      _FlameTroopersEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _FlechettesEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _GasAttackEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _PropagandaEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_SpecialStrikeEstimationData> estimationItem) =>
      GameFieldControlsSpecialStrikesCardBrief(type: estimationItem.data.type);
}
