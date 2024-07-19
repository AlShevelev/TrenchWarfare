part of aggressive_player_ai;

class DoNothingEstimationProcessor extends UnitEstimationProcessorBase {
  DoNothingEstimationProcessor({required super.actions});

  @override
  double estimate() {
    // TODO: implement estimate
    throw UnimplementedError();
  }

  @override
  Future<GameFieldCellRead> processAction() {
    // Must disable the unit
    // Must return an actual cell with the unit
    throw UnimplementedError();
  }
}