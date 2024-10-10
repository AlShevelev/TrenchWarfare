part of money_spending_phase_library;

/// Should we place a trench in general?
class _TrenchEstimator extends Estimator<_TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _TrenchEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_TerrainModifierEstimationData>> estimate() {
    Logger.info('_TrenchEstimator: estimate() started', tag: 'MONEY_SPENDING');

    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.trench,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_TrenchEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final cellsPossibleToBuildExt = cellsPossibleToBuild.where((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
        return false;
      }

      return cell.units.any((u) => u.type == UnitType.infantry || u.type == UnitType.machineGuns);
    }).toList(growable: false);

    if (cellsPossibleToBuildExt.isEmpty) {
      Logger.info('_TrenchEstimator: estimate() completed [cellsPossibleToBuildExt.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_TrenchEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsPossibleToBuildExt
        .map((c) => EstimationResult<_TerrainModifierEstimationData>(
              weight:
                  1.0 + c.units.count((u) => u.type == UnitType.infantry || u.type == UnitType.machineGuns),
              data: _TerrainModifierEstimationData(
                cell: c,
                type: TerrainModifierType.trench,
              ),
            ))
        .toList(growable: false);

    Logger.info('_TrenchEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
