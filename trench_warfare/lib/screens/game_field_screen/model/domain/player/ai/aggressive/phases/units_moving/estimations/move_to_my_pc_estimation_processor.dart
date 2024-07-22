part of aggressive_player_ai;

class MoveToMyPcEstimationProcessor extends UnitEstimationProcessorBase {
  GameFieldCellRead? _nearestPcInDanger;

  MoveToMyPcEstimationProcessor({
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

    final allMyReachablePCsInDanger = _gameField.cells
        .where((c) => c.nation == _myNation && c.productionCenter != null && _unit.isLand == c.isLand)
        .where((c) {
      final influenceCell = _influences.getItem(c.row, c.col);

      final myInfluence = _getMyInfluence(influenceCell);
      final enemyInfluence = _getOpponentsInfluence(influenceCell);

      return enemyInfluence > 0 && enemyInfluence >= myInfluence;
    });

    if (allMyReachablePCsInDanger.isEmpty) {
      return 0;
    }

    final pathFacade = PathFacade(_gameField);

    final nearestPcInDanger = allMyReachablePCsInDanger
        .map((c) => Tuple2(c, pathFacade.calculatePath(startCell: _cell, endCell: c).length))
        .where((i) => i.item2 > 0)
        .sorted((i1, i2) => i1.item2.compareTo(i2.item2))
        .firstOrNull
        ?.item1;

    if (nearestPcInDanger == null) {
      return 0;
    }

    _nearestPcInDanger = nearestPcInDanger;

    return _calculateWeight(nearestPcInDanger);
  }

  @override
  Future<void> processAction() async {
    await _actions.move(_unit, from: _cell, to: _nearestPcInDanger!);
  }

  double _getMyInfluence(InfluenceMapItemRead influenceItem) =>
      (_unit.isLand ? influenceItem.getLand(_myNation) : influenceItem.getSea(_myNation)) ?? 0.0;

  double _getOpponentsInfluence(InfluenceMapItemRead influenceItem) =>
      _allOpponents
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

    weight *= math.sqrt(enemyInfluence - myInfluence);

    if (cell.productionCenter!.type == ProductionCenterType.airField) {
      weight /= 2.0;
    }

    return weight;
  }
}
