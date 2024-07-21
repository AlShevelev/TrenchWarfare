part of aggressive_player_ai;

class DoNothingEstimationProcessor extends UnitEstimationProcessorBase {
  DoNothingEstimationProcessor({
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
    if (_cell.productionCenter != null) {
      final allOpponents = _allOpponents;
      final influenceCell = _influences.getItem(_cell.row, _cell.col);

      final sumDanger = allOpponents.map((o) => influenceCell.getCombined(o)).sum;
      if (sumDanger > 0) {
        return (sumDanger / influenceCell.getCombined(_myNation)) + 1;
      }
    }

    if (_unit.health / _unit.maxHealth < 0.5) {
      return _unit.maxHealth / (_unit.health * 2);
    }

    return 0;
  }

  @override
  Future<GameFieldCellRead> processAction() {
    _unit.setState(UnitState.disabled);

    return Future.value(_cell);
  }
}
