part of aggressive_player_ai;

class SpecialStrikeEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final SpecialStrikeType type;

  SpecialStrikeEstimationData({required this.cell, required this.type});
}
