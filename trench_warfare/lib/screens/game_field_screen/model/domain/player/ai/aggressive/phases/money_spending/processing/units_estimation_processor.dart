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

class _UnitsEstimationProcessor extends _EstimationProcessorBase<_UnitsBuildingEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.5;

  _UnitsEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
    required super.unitUpdateResultBridge,
  });

  @override
  Iterable<EstimationResult<_UnitsBuildingEstimationData>> _makeEstimations() {
    final List<EstimationResult<_UnitsBuildingEstimationData>> result = [];

    final types = [
      UnitType.armoredCar,
      UnitType.artillery,
      UnitType.infantry,
      UnitType.cavalry,
      UnitType.machineGunnersCart,
      UnitType.machineGuns,
      UnitType.tank,
    ];

    if (!_metadata.landOnlyAi) {
      types.add(UnitType.destroyer);
      types.add(UnitType.cruiser);
      types.add(UnitType.battleship);
    }

    for (final type in types) {
      final estimator = _UnitsBuildingEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney,
          influenceMap: _influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_UnitsBuildingEstimationData> estimationItem) =>
      GameFieldControlsUnitCardBrief(type: estimationItem.data.type);
}
