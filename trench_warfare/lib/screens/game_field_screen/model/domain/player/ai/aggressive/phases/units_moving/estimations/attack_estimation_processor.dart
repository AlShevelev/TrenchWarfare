/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of units_moving_phase_library;

class _AttackEstimationItem {
  final GameFieldCellRead cell;
  final double weight;

  _AttackEstimationItem({required this.cell, required this.weight});
}

class _AttackEstimationProcessor extends _UnitEstimationProcessorBase {
  late final List<_AttackEstimationItem> _estimationResult;

  _AttackEstimationProcessor({
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

    final allVictimCells = _getAllVictimCells();

    if (allVictimCells.isEmpty) {
      return 0;
    }

    _estimationResult = allVictimCells
        .map((c) => _AttackEstimationItem(
              cell: c,
              weight: _calculateWeight(c, attacker: _unit, defender: c.activeUnit!),
            ))
        .toList(growable: false);

    return _estimationResult.map((i) => i.weight).average();
  }

  @override
  Future<List<UnitUpdateResultItem>?> processAction() async {
    final weightIndex =
        RandomGen.randomWeight(_estimationResult.map((i) => i.weight).toList(growable: false));
    final target = _estimationResult[weightIndex!];

    return await _actions.move(_unit, from: _cell, to: target.cell);
  }

  Iterable<GameFieldCellRead> _getAllVictimCells() {
    const cellsMax = 3;

    final cellCandidates = <GameFieldCellRead>[];

    for (var r = 1; r <= _unit.maxMovementPoints.toInt(); r++) {
      final cells = RandomGen.shiftItems(
        _gameField.findCellsAroundR(_cell, radius: r) as List<GameFieldCell>,
      );

      for (final c in cells) {
        if (c.activeUnit != null &&
            c.nation != _myNation &&
            _isEnemyCell(c) &&
            _pathFacade.canReach(_unit, startCell: _cell, endCell: c) != null) {
          cellCandidates.add(c);

          if (cellCandidates.length == cellsMax) {
            return cellCandidates;
          }
        }
      }
    }

    return cellCandidates;
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

    return weight + 1;
  }
}
