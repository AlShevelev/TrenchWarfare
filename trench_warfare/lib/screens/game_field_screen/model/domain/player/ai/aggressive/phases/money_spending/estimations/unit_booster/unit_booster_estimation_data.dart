part of aggressive_player_ai;

class UnitBoosterEstimationData {
  final GameFieldCellRead cell;

  final UnitBoost type;

  final int unitIndex;

  UnitBoosterEstimationData({
    required this.cell,
    required this.type,
    required this.unitIndex,
  });
}
