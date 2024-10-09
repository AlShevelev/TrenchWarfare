part of money_spending_phase_library;

class _FlechettesCellWithFactors {
  final GameFieldCellRead cell;

  final double unitsSumPower;

  final int unitsQuantity;

  _FlechettesCellWithFactors({
    required this.cell,
    required this.unitsSumPower,
    required this.unitsQuantity,
  });
}

class _FlechettesEstimator extends Estimator<_SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _FlechettesEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_SpecialStrikeEstimationData>> estimate() {
    Logger.info('_FlechettesEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _metadata);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      SpecialStrikeType.flechettes,
      _nationMoney.totalSum,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_FlechettesEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (!cellFromMap.hasAny(_myNation)) {
            return null;
          }

          return _FlechettesCellWithFactors(
            cell: cell,
            unitsQuantity: cell.units.where((u) => !u.isMechanical).length,
            unitsSumPower:
                cell.units.where((u) => !u.isMechanical).map((u) => UnitPowerEstimation.estimate(u)).sum,
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_FlechettesEstimator: estimate() completed [cellsWithFactors.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_FlechettesEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors.map((c) => EstimationResult<_SpecialStrikeEstimationData>(
          weight: 1.0 + c!.unitsQuantity * c.unitsSumPower * getMoneyWeightFactor(_nationMoney),
          data: _SpecialStrikeEstimationData(
            cell: c.cell,
            type: SpecialStrikeType.flechettes,
          ),
        ));

    Logger.info('_FlechettesEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
