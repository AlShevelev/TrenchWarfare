part of units_moving_phase_library;

class _CarrierInterceptionEstimationUnit {
  final GameFieldCellRead cell;
  final double weight;

  _CarrierInterceptionEstimationUnit({required this.cell, required this.weight});
}

class _CarrierInterceptionEstimationProcessor extends _UnitEstimationProcessorBase {
  late final List<_CarrierInterceptionEstimationUnit> _estimationResult;

  _CarrierInterceptionEstimationProcessor({
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

    if (_unit.type != UnitType.destroyer ||
        _unit.type != UnitType.cruiser ||
        _unit.type != UnitType.battleship) {
      return 0;
    }

    const cellsMax = 5;

    final allEnemies = _metadata.getEnemies(_myNation);

    for(final c in _gameField.cells) {
      if (c.activeUnit?.type == UnitType.carrier && allEnemies.contains(c.nation)) {
        final pathLen = _pathFacade.calculatePath(startCell: _cell, endCell: c).length;

        // Can't reach
        if (pathLen == 0) {
          continue;
        }

        final carrierStrength = UnitPowerEstimation.estimate(c.activeUnit!);

        final weight = _unit.maxMovementPoints * carrierStrength * (1.0 / pathLen);
        _estimationResult.add(_CarrierInterceptionEstimationUnit(cell: c, weight: weight));

        if (_estimationResult.length == cellsMax) {
          break;
        }
      }
    }

    return _estimationResult.map((i) => i.weight).average();
  }

  @override
  Future<List<MovementResultItem>?> processAction() async {
    final weightIndex =
        RandomGen.randomWeight(_estimationResult.map((i) => i.weight).toList(growable: false));
    final target = _estimationResult[weightIndex!];

    return await _actions.move(_unit, from: _cell, to: target.cell);
  }
}
