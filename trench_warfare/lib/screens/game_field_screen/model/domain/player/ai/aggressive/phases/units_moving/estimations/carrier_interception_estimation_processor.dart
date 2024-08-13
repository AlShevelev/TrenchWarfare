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
    if (_unit.type != UnitType.destroyer ||
        _unit.type != UnitType.cruiser ||
        _unit.type != UnitType.battleship) {
      return 0;
    }

    final allEnemies = _metadata.getMyEnemies(_myNation);

    final pathFacade = PathFacade(_gameField);

    _estimationResult = _gameField.cells
        .where((c) => c.activeUnit?.type == UnitType.carrier && allEnemies.contains(c.nation))
        .map((c) {
          final pathLen = pathFacade.calculatePath(startCell: _cell, endCell: c).length;

          // Can't reach
          if (pathLen == 0) {
            return _CarrierInterceptionEstimationUnit(cell: c, weight: 0);
          }

          final carrierStrength = UnitPowerEstimation.estimate(c.activeUnit!);

          final weight = _unit.maxMovementPoints * carrierStrength * (1.0 / pathLen);
          return _CarrierInterceptionEstimationUnit(cell: c, weight: weight);
        })
        .where((c) => c.weight != 0)
        .toList(growable: false);

    return _estimationResult.map((i) => i.weight).average();
  }

  @override
  Future<void> processAction() async {
    final weightIndex =
        RandomGen.randomWeight(_estimationResult.map((i) => i.weight).toList(growable: false));
    final target = _estimationResult[weightIndex!];

    await _actions.move(_unit, from: _cell, to: target.cell);
  }
}
