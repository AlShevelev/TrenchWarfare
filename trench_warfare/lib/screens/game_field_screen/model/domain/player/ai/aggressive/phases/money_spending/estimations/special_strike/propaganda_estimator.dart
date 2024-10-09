part of money_spending_phase_library;

class _PropagandaCellWithFactors {
  final GameFieldCellRead cell;

  final double unitPower;

  _PropagandaCellWithFactors({
    required this.cell,
    required this.unitPower,
  });
}

class _PropagandaEstimator extends Estimator<_SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _PropagandaEstimator({
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
    Logger.info('_PropagandaEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _metadata);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      SpecialStrikeType.propaganda,
      _nationMoney.totalSum,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_PropagandaEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (!cellFromMap.hasAny(_myNation)) {
        return null;
      }

      return _PropagandaCellWithFactors(
        cell: cell,
        unitPower: UnitPowerEstimation.estimate(cell.activeUnit!),
      );
    })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_PropagandaEstimator: estimate() completed [cellsWithFactors.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_PropagandaEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors.map((c) => EstimationResult<_SpecialStrikeEstimationData>(
      weight: 1.0 + c!.unitPower * getMoneyWeightFactor(_nationMoney),
      data: _SpecialStrikeEstimationData(
        cell: c.cell,
        type: SpecialStrikeType.propaganda,
      ),
    ));

    Logger.info('_PropagandaEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}