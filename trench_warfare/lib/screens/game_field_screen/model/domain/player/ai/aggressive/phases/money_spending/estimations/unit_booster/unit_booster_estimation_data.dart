part of money_spending_phase_library;

class _UnitBoosterEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final UnitBoost type;

  final int unitIndex;

  _UnitBoosterEstimationData({
    required this.cell,
    required this.type,
    required this.unitIndex,
  });
}
