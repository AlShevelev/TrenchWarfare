part of money_spending_phase_library;

class _TransportCellWithFactors {
  final GameFieldCellRead cell;

  final int unitIndex;

  final double unitPower;

  final double unitMaxMovementPoints;

  final UnitType type;

  _TransportCellWithFactors({
    required this.cell,
    required this.unitIndex,
    required this.unitPower,
    required this.unitMaxMovementPoints,
    required this.type,
  });
}

/// Should we add a transport booster in general?
class _TransportEstimator extends Estimator<_UnitBoosterEstimationData> {
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
    Logger.info('_TransportEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = UnitBoosterBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_TransportEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    final List<_TransportCellWithFactors> cellsPossibleToBuildExt = [];

    for (final cell in cellsPossibleToBuild) {
      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);
        if (UnitBoosterBuildCalculator.canBuildForUnit(unit, _type)) {
          cellsPossibleToBuildExt.add(_TransportCellWithFactors(
            cell: cell,
            unitIndex: i,
            unitPower: UnitPowerEstimation.estimate(unit),
            unitMaxMovementPoints: unit.maxMovementPoints,
            type: unit.type,
          ));
        }
      }
    }

    if (cellsPossibleToBuildExt.isEmpty) {
      Logger.info('_TransportEstimator: estimate() completed [cellsPossibleToBuildExt.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_TransportEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsPossibleToBuildExt
        .map((c) => EstimationResult<_UnitBoosterEstimationData>(
              weight: _typeFactor(c.type) *
                  (1.0 + c.unitPower + _maxMovementPointsToWeight(c.unitMaxMovementPoints)),
              data: _UnitBoosterEstimationData(
                cell: c.cell,
                type: _type,
                unitIndex: c.unitIndex,
              ),
            ))
        .toList(growable: false);

    Logger.info('_TransportEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }

  double _maxMovementPointsToWeight(double maxMovementPoints) =>
      maxMovementPoints > Unit.absoluteMaxMovementPoints
          ? 0.0
          : math.pow(Unit.absoluteMaxMovementPoints - maxMovementPoints, 3.0).toDouble();

  double _typeFactor(UnitType type) => type == UnitType.artillery || type == UnitType.machineGuns ? 2.0 : 1.0;
}
