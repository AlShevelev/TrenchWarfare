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

    const candidatesMax = 2;
    var candidateCounter = 0;

    GameFieldCellRead? nearestEnemyPc;
    var minDistance = 1000000;

    var radius = 1;

    var cells = RandomGen.shiftItems(
      _gameField.findCellsAroundR(_cell, radius: radius) as List<GameFieldCell>,
    );

    while(cells.isNotEmpty) {
      for (final c in cells) {
        if (c.productionCenter != null && _unit.isLand == c.isLand && _isEnemyCell(c)) {
          final path = _pathFacade.calculatePath(startCell: _cell, endCell: c);
          if (path.isEmpty) {
            continue;
          }

          if (path.length < minDistance) {
            minDistance = path.length;
            nearestEnemyPc = c;
            candidateCounter++;
          }
        }
      }

      if (candidateCounter >= candidatesMax) {
        break;
      }

      radius++;
      cells = RandomGen.shiftItems(
        _gameField.findCellsAroundR(_cell, radius: radius) as List<GameFieldCell>,
      );
    }

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
