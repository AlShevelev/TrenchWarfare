part of money_spending_phase_library;

class _FlameTroopersCellWithFactors {
  final GameFieldCellRead cell;

  final double unitPower;

  _FlameTroopersCellWithFactors({
    required this.cell,
    required this.unitPower,
  });
}

class _FlameTroopersEstimator extends Estimator<_SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _FlameTroopersEstimator({
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
    Logger.info('_FlameTroopersEstimator: estimate() started', tag: 'MONEY_SPENDING');

    final buildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _metadata);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      SpecialStrikeType.flameTroopers,
      _nationMoney.totalSum,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_FlameTroopersEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (!cellFromMap.hasAny(_myNation)) {
            return null;
          }

          return _FlameTroopersCellWithFactors(
            cell: cell,
            unitPower: UnitPowerEstimation.estimate(cell.activeUnit!),
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_FlameTroopersEstimator: estimate() completed [cellsWithFactors.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_FlameTroopersEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors.map((c) => EstimationResult<_SpecialStrikeEstimationData>(
          weight: 1.0 + c!.unitPower * getMoneyWeightFactor(_nationMoney),
          data: _SpecialStrikeEstimationData(
            cell: c.cell,
            type: SpecialStrikeType.flameTroopers,
          ),
        ));

    Logger.info('_FlameTroopersEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
