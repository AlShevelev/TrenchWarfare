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

class _MoveToMyPcEstimationProcessor extends _UnitEstimationProcessorBase {
  GameFieldCellRead? _nearestPcInDanger;

  _MoveToMyPcEstimationProcessor({
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

    GameFieldCellRead? nearestPcInDanger;
    var minDistance = 1000000;

    var radius = 1;

    var cells = RandomGen.shiftItems(
      _gameField.findCellsAroundR(_cell, radius: radius) as List<GameFieldCell>,
    );

    while(cells.isNotEmpty) {
      for (final c in cells) {
        if (c.nation == _myNation && c.productionCenter != null && _unit.isLand == c.isLand) {
          final influenceCell = _influences.getItem(c.row, c.col);
          final myInfluence = _getMyInfluence(influenceCell);
          final enemyInfluence = _getOpponentsInfluence(influenceCell);

          if (enemyInfluence > 0 && enemyInfluence >= myInfluence) {
            final path = _pathFacade.calculatePath(startCell: _cell, endCell: c);
            if (path.isEmpty) {
              continue;
            }

            if (path.length < minDistance) {
              minDistance = path.length;
              nearestPcInDanger = c;
              candidateCounter++;
            }
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

    if (nearestPcInDanger == null) {
      return 0;
    }

    _nearestPcInDanger = nearestPcInDanger;

    return _calculateWeight(nearestPcInDanger);
  }

  @override
  Future<List<UnitUpdateResultItem>?> processAction() async {
    return await _actions.move(_unit, from: _cell, to: _nearestPcInDanger!);
  }

  double _getMyInfluence(InfluenceMapItemRead influenceItem) =>
      (_unit.isLand ? influenceItem.getLand(_myNation) : influenceItem.getSea(_myNation)) ?? 0.0;

  double _getOpponentsInfluence(InfluenceMapItemRead influenceItem) =>
      _allEnemies
          .map((o) => (_unit.isLand ? influenceItem.getLand(o) : influenceItem.getSea(o)) ?? 0.0)
          .sum;

  double _calculateWeight(GameFieldCellRead cell) {
    var weight = switch(cell.productionCenter!.level) {
      ProductionCenterLevel.level1 => 1.0,
      ProductionCenterLevel.level2 => 2.0,
      ProductionCenterLevel.level3 => 3.0,
      ProductionCenterLevel.level4 => 4.0,
      ProductionCenterLevel.capital => 5.0,
    };

    final influenceCell = _influences.getItem(cell.row, cell.col);
    final myInfluence = _getMyInfluence(influenceCell);
    final enemyInfluence = _getOpponentsInfluence(influenceCell);

    weight *= 5.0 * math.sqrt(enemyInfluence - myInfluence);

    if (cell.productionCenter!.type == ProductionCenterType.airField) {
      weight /= 2.0;
    }

    return weight;
  }
}
