part of units_moving_phase_library;

class _MoveToEnemyPcEstimationProcessor extends _UnitEstimationProcessorBase {
  GameFieldCellRead? _nearestEnemyPc;

  _MoveToEnemyPcEstimationProcessor({
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
    if (_unit.isInDefenceMode) {
      return 0;
    }

    if (_unit.type == UnitType.carrier) {
      return 0;
    }

    final allEnemyReachablePCs = _gameField.cells.where(
        (c) => c.productionCenter != null && _unit.isLand == c.isLand && _allEnemies.contains(c.nation));

    if (allEnemyReachablePCs.isEmpty) {
      return 0;
    }

    final pathFacade = PathFacade(_gameField);

    final nearestEnemyPc = allEnemyReachablePCs
        .map((c) => Tuple2(c, pathFacade.calculatePath(startCell: _cell, endCell: c).length))
        .where((i) => i.item2 > 0)
        .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
        .firstOrNull
        ?.item1;

    if (nearestEnemyPc == null) {
      return 0;
    }

    _nearestEnemyPc = nearestEnemyPc;

    return _calculateWeight(nearestEnemyPc);
  }

  @override
  Future<List<MovementResultItem>?> processAction() async {
    return await _actions.move(_unit, from: _cell, to: _nearestEnemyPc!);
  }

  double _calculateWeight(GameFieldCellRead cell) {
    var weight = switch(cell.productionCenter!.level) {
      ProductionCenterLevel.level1 => 2.0,
      ProductionCenterLevel.level2 => 4.0,
      ProductionCenterLevel.level3 => 6.0,
      ProductionCenterLevel.level4 => 8.0,
      ProductionCenterLevel.capital => 10.0,
    };

    if (cell.productionCenter!.type == ProductionCenterType.airField) {
      weight /= 2.0;
    }

    return weight;
  }
}
