part of units_moving_phase_library;

/// A unit in defence mode can attack some enemy units around
class _AttackUnitInDefenceModeEstimationProcessor extends _UnitEstimationProcessorBase {
  late final List<_AttackEstimationItem> _estimationResult;

  _AttackUnitInDefenceModeEstimationProcessor({
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
    if (!_unit.isInDefenceMode || _unit.type == UnitType.carrier) {
      return 0;
    }

    if (_unit.movementPoints == 0 || _unit.state == UnitState.disabled) {
      return 0;
    }

    final allVictimCells = _gameField
        .findCellsAround(_cell)
        .where((c) => c.nation != _myNation && c.units.isNotEmpty && _isEnemyCell(c))
        .toList(growable: false);

    if (allVictimCells.isEmpty) {
      return 0;
    }

    _estimationResult = allVictimCells
        .map(
          (c) => _AttackEstimationItem(
            cell: c,
            weight: _calculateWeight(
              attackerCell: _cell,
              defenderCell: c,
              attacker: _unit,
              defender: c.activeUnit!,
            ),
          ),
        )
        .toList(growable: false);

    final weight = _estimationResult.map((i) => i.weight).average();
    return weight;
  }

  @override
  Future<List<MovementResultItem>?> processAction() async {
    final weightIndex =
        RandomGen.randomWeight(_estimationResult.map((i) => i.weight).toList(growable: false));
    final target = _estimationResult[weightIndex!];

    return await _actions.move(_unit, from: _cell, to: target.cell);
  }

  double _calculateWeight({
    required GameFieldCellRead attackerCell,
    required GameFieldCellRead defenderCell,
    required Unit attacker,
    required Unit defender,
  }) {
    double weight = UnitPowerEstimation.estimate(attacker) / UnitPowerEstimation.estimate(defender);

    if ((attacker.hasArtillery || attackerCell.terrainModifier?.type == TerrainModifierType.landFort) &&
        !defender.hasArtillery) {
      weight *= 1.5;
    }

    if (attacker.hasMachineGun && !defender.isMechanical) {
      weight *= 1.5;
    }

    final result = math.exp(math.pow(weight + 1, 1.5));
    return result;
  }
}
