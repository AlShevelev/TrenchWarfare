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

class _CarriersEstimationProcessor extends _EstimationProcessorBase<_CarriersBuildingEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.5;

  _CarriersEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
    required super.unitUpdateResultBridge,
  });

  @override
  Iterable<EstimationResult<_CarriersBuildingEstimationData>> _makeEstimations() =>
      _CarriersBuildingEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.totalSum,
        metadata: _metadata,
      ).estimate();

  @override
  GameFieldControlsCard _toCard(EstimationResult<_CarriersBuildingEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: UnitType.carrier);
}
