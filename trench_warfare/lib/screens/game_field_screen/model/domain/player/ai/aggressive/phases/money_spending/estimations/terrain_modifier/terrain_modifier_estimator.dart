part of money_spending_phase_library;

class _TerrainModifierEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final TerrainModifierType type;

  _TerrainModifierEstimationData({required this.cell, required this.type});
}
