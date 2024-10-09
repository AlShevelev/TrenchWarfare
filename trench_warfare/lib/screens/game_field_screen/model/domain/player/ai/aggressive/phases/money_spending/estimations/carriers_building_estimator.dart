part of money_spending_phase_library;

class _CarriersBuildingEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  _CarriersBuildingEstimationData({required this.cell});
}

/// Should we hire a unit in general?
class _CarriersBuildingEstimator extends Estimator<_CarriersBuildingEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final MapMetadataRead _metadata;

  /// The maximum quantity of carriers you can get
  static const _maxCarries = 3;

  static const _defaultWeight = 100.0;

  _CarriersBuildingEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_CarriersBuildingEstimationData>> estimate() {
    Logger.info('_CarriersBuildingEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(UnitType.carrier, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_CarriersBuildingEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    // check quantity
    final totalCarriers = _gameField.cells.map((c) {
      if (c.nation != _myNation || c.units.isEmpty) {
        return 0;
      }

      return c.units.count((u) => u.type == UnitType.carrier);
    }).sum;

    // We've got enough carriers for now
    if (totalCarriers >= _maxCarries) {
      Logger.info('_CarriersBuildingEstimator: estimate() completed [totalCarriers >= _maxCarries]', tag: 'MONEY_SPENDING');
      return [];
    }

    final targetCalculator = CarriersTargetCalculator(
      gameField: _gameField,
      myNation: _myNation,
      metadata: _metadata,
    );

    // It is not worth it - too complicated
    if (targetCalculator.getTarget() == null) {
      Logger.info('_CarriersBuildingEstimator: estimate() completed [targetCalculator.getTarget() == null]', tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_CarriersBuildingEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsPossibleToBuild
        .map((cell) => EstimationResult(
              weight: _defaultWeight,
              data: _CarriersBuildingEstimationData(cell: cell),
            ))
        .toList(growable: false);

    Logger.info('_CarriersBuildingEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
