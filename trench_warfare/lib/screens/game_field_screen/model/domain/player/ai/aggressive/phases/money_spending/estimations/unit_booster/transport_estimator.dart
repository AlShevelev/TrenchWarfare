part of money_spending_phase_library;

class _TransportCellWithFactors {
  final GameFieldCellRead cell;

  final int unitIndex;

  final double unitPower;

  final double unitMaxMovementPoints;

  _TransportCellWithFactors({
    required this.cell,
    required this.unitIndex,
    required this.unitPower,
    required this.unitMaxMovementPoints,
  });
}

/// Should we add a transport booster in general?
class _TransportEstimator implements Estimator<_UnitBoosterEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  static const _type = UnitBoost.transport;

  _TransportEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney;

  @override
  Iterable<EstimationResult<_UnitBoosterEstimationData>> estimate() {
    final buildCalculator = UnitBoosterBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final List<_TransportCellWithFactors> cellsPossibleToBuildExt = [];

    for (final cell in cellsPossibleToBuild) {
      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);
        if (buildCalculator.canBuildForUnit(unit, _type)) {
          cellsPossibleToBuildExt.add(_TransportCellWithFactors(
            cell: cell,
            unitIndex: i,
            unitPower: UnitPowerEstimation.estimate(unit),
            unitMaxMovementPoints: unit.maxMovementPoints,
          ));
        }
      }
    }

    if (cellsPossibleToBuildExt.isEmpty) {
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<_UnitBoosterEstimationData>(
          weight: 1.0 + c.unitPower + _maxMovementPointsToWeight(c.unitMaxMovementPoints),
          data: _UnitBoosterEstimationData(
            cell: c.cell,
            type: _type,
            unitIndex: c.unitIndex,
          ),
        ));
  }

  double _maxMovementPointsToWeight(double maxMovementPoints) =>
      maxMovementPoints > Unit.absoluteMaxMovementPoints
          ? 0.0
          : math.pow(Unit.absoluteMaxMovementPoints - maxMovementPoints, 1.5).toDouble();
}
