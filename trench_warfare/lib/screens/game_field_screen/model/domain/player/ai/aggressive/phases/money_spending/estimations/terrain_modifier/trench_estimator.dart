part of aggressive_player_ai;

/// Should we place a trench in general?
class TrenchEstimator implements Estimator<TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  TrenchEstimator({
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
  Iterable<EstimationResult<TerrainModifierEstimationData>> estimate() {
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.trench,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
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
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<TerrainModifierEstimationData>(
          weight: 1.0 + c.units.count((u) => u.type == UnitType.infantry || u.type == UnitType.machineGuns),
          data: TerrainModifierEstimationData(
            cell: c,
            type: TerrainModifierType.trench,
          ),
        ));
  }
}
