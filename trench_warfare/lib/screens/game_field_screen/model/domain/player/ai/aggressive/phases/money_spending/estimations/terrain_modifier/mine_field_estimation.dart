part of aggressive_player_ai;

/// Should we place a mine field in general?
class MineFieldsEstimator implements Estimator<TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final TerrainModifierType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _weight = 2.0;

  MineFieldsEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required TerrainModifierType type,
    required MoneyUnit nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _type = type,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<TerrainModifierEstimationData>> estimate() {
    if (_type != TerrainModifierType.landMine && _type != TerrainModifierType.seaMine) {
      throw ArgumentError("Can't make an estimation for this type of terrain modifier: $_type");
    }

    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getAllAggressive().where((a) => a != _myNation).toList(growable: true);

    final cellsPossibleToBuildExt = cellsPossibleToBuild.where((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (cellFromMap.hasAny(_myNation)) {
        return false;
      }

      return allAggressors.any((a) => cellFromMap.hasAny(a));
    }).toList(growable: false);

    // Our rivals are nearby, but we are not
    if (cellsPossibleToBuildExt.isEmpty) {
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<TerrainModifierEstimationData>(
          weight: _weight,
          data: TerrainModifierEstimationData(
            cell: c,
            type: _type,
          ),
        ));
  }
}
