part of aggressive_player_ai;

class MoveToEnemyPcEstimationProcessor extends UnitEstimationProcessorBase {
  MoveToEnemyPcEstimationProcessor({
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
    if (_unit.type == UnitType.carrier) {
      return 0;
    }

    // TODO: implement estimate
    throw UnimplementedError();
  }

  @override
  Future<void> processAction() async {
    // TODO: implement processAction
    throw UnimplementedError();
  }
}
