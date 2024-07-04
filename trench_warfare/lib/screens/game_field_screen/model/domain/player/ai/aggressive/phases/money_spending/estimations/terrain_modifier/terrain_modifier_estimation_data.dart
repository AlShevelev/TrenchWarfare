part of aggressive_player_ai;

class TerrainModifierEstimationData implements EstimationData {
  final GameFieldCellRead cell;

  final TerrainModifierType type;

  TerrainModifierEstimationData({required this.cell, required this.type});
}
