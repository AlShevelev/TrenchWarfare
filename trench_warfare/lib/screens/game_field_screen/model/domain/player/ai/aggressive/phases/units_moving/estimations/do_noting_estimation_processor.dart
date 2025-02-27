part of units_moving_phase_library;

class _DoNothingEstimationProcessor extends _UnitEstimationProcessorBase {
  _DoNothingEstimationProcessor({
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

    if (_cell.productionCenter != null) {
      final influenceCell = _influences.getItem(_cell.row, _cell.col);

      final sumDangerInfluence = _allEnemies.map((o) => influenceCell.getCombined(o)).sum;
      final mySafeInfluence = influenceCell.getCombined(_myNation);

      if (sumDangerInfluence > 0) {
        if (mySafeInfluence != 0) {
          return 50.0 * (sumDangerInfluence / mySafeInfluence) + 1;
        } else {
          return 1000;
        }
      }
    }

    if (_unit.health / _unit.maxHealth < 0.5) {
      return _unit.maxHealth / (_unit.health * 2);
    }

    return 0;
  }

  @override
  Future<List<MovementResultItem>?> processAction() async {
    _unit.setState(UnitState.disabled);
    return null;
  }
}
