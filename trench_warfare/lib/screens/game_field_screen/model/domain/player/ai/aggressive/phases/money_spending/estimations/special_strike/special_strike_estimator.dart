part of money_spending_phase_library;

class _SpecialStrikeEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final SpecialStrikeType type;

  _SpecialStrikeEstimationData({required this.cell, required this.type});
}
