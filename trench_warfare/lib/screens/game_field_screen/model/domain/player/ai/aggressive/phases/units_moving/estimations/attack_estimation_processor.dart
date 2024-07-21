part of aggressive_player_ai;

class _AttackEstimationUnit {
  final GameFieldCellRead cell;
  final double weight;

  _AttackEstimationUnit({required this.cell, required this.weight});
}

class AttackEstimationProcessor extends UnitEstimationProcessorBase {
  late final List<_AttackEstimationUnit> _estimationResult;

  AttackEstimationProcessor({
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
    final allVictimCells = _getAllVictimCells();

    if (allVictimCells.isEmpty) {
      return 0;
    }

    _estimationResult = allVictimCells
        .map((c) => _AttackEstimationUnit(
              cell: c,
              weight: _calculateWeight(c, attacker: _unit, defender: c.activeUnit!),
            ))
        .toList(growable: false);

    return _estimationResult.map((i) => i.weight).average();
  }

  @override
  Future<GameFieldCellRead> processAction() async {
    final weightIndex =
        RandomGen.randomWeight(_estimationResult.map((i) => i.weight).toList(growable: false));
    final target = _estimationResult[weightIndex!];

    await _actions.move(_unit, from: _cell, to: target.cell);

    return Future.value(target.cell);
  }

  Iterable<GameFieldCellRead> _getAllVictimCells() {
    final allCellsAround = <GameFieldCellRead>[];
    for (var r = 1; r <= _unit.maxMovementPoints; r++) {
      allCellsAround.addAll(_gameField.findCellsAroundR(_cell, radius: r));
    }

    final pathFacade = PathFacade(_gameField);

    return allCellsAround
        .where((c) =>
            c.activeUnit != null &&
            c.nation != _myNation &&
            _isEnemyCell(c) &&
            pathFacade.canReach(_unit, startCell: _cell, endCell: c) != null)
        .toList(growable: false);
  }

  double _calculateWeight(
    GameFieldCellRead defenderCell, {
    required Unit attacker,
    required Unit defender,
  }) {
    double weight = UnitPowerEstimation.estimate(attacker) / UnitPowerEstimation.estimate(defender);

    if (attacker.hasArtillery && !defender.hasArtillery) {
      weight *= 1.5;
    }

    if (attacker.hasMachineGun && !defender.isMechanical) {
      weight *= 1.5;
    }

    if (defenderCell.productionCenter != null) {
      weight *= 1.5;
    }

    return weight;
  }
}
