part of money_spending_phase_library;

class _LandFortCellWithFactors {
  final GameFieldCellRead cell;

  final bool onRoad;

  final bool blockBridge;

  final int pcNearbyCount;

  _LandFortCellWithFactors({
    required this.cell,
    required this.onRoad,
    required this.blockBridge,
    required this.pcNearbyCount,
  });
}

/// Should we place a land fort in general?
class _LandFortEstimator extends Estimator<_TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _weightFactor = 2.0;

  _LandFortEstimator({
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
    Logger.info('_LandFortEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.landFort,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_LandFortEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          if (cell.units.isEmpty) {
            return null;
          }

          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
            return null;
          }

          final cellsAround = _gameField.findCellsAround(cell);

          final onRoad = cell.hasRoad && !cell.hasRiver;

          return _LandFortCellWithFactors(
            cell: cell,
            onRoad: onRoad,
            blockBridge: onRoad && cellsAround.any((c) => c.hasRoad && c.hasRiver),
            pcNearbyCount: cellsAround.count((c) => c.nation == _myNation && c.productionCenter != null),
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_LandFortEstimator: estimate() completed [cellsWithFactors.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_LandFortEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors
        .map((c) => EstimationResult<_TerrainModifierEstimationData>(
              weight: 1.0 +
                  (c!.onRoad ? _weightFactor : 0) +
                  (c.blockBridge ? _weightFactor : 0) +
                  c.pcNearbyCount * _weightFactor,
              data: _TerrainModifierEstimationData(
                cell: c.cell,
                type: TerrainModifierType.landFort,
              ),
            ))
        .toList(growable: false);

    Logger.info('_LandFortEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
