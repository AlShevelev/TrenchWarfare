part of aggressive_player_ai;

class LandFortEstimationData {
  final GameFieldCellRead cell;

  final TerrainModifierType type;

  LandFortEstimationData({required this.cell, required this.type});
}

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
class LandFortEstimator implements Estimator<LandFortEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _weightFactor = 2.0;

  LandFortEstimator({
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
  Iterable<EstimationResult<LandFortEstimationData>> estimate() {
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.landFort,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getAllAggressive().where((a) => a != _myNation).toList(growable: true);

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
      return [];
    }

    return cellsWithFactors.map((c) => EstimationResult<LandFortEstimationData>(
          weight: 1.0 +
              (c!.onRoad ? _weightFactor : 0) +
              (c.blockBridge ? _weightFactor : 0) +
              c.pcNearbyCount * _weightFactor,
          data: LandFortEstimationData(
            cell: c.cell,
            type: TerrainModifierType.landFort,
          ),
        ));
  }
}
