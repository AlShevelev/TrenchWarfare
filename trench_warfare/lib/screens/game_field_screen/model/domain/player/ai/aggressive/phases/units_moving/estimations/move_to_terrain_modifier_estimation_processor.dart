part of aggressive_player_ai;

class MoveToTerrainModifierEstimationProcessor extends UnitEstimationProcessorBase {
  MoveToTerrainModifierEstimationProcessor({
    required super.actions,
    required super.influences,
    required super.unit,
    required super.cell,
    required super.myNation,
    required super.metadata,
    required super.gameField,
  });

  @override
  double _estimateInternal() {
    // TODO: implement estimate
    throw UnimplementedError();
  }

  @override
  Future<GameFieldCellRead> processAction() async {
    // TODO: implement processAction
    throw UnimplementedError();
  }
}
