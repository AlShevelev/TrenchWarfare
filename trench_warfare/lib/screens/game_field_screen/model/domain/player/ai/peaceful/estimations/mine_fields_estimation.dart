part of peaceful_player_ai;

class MineFieldsEstimationResult extends EstimationResult {
  final Iterable<GameFieldCellRead> cellsPossibleToPlace;

  MineFieldsEstimationResult(
    super.weight, {
    required this.cellsPossibleToPlace,
  });
}

/// Should we place mine fields in general?
class MineFieldsEstimator implements Estimator<MineFieldsEstimationResult> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final TerrainModifierType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type == TerrainModifierType.landMine;

  double get _correctionFactor => _isLand ? 1.0 : 2.0;

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
  MineFieldsEstimationResult estimate() {
    if (_type != TerrainModifierType.landMine && _type != TerrainModifierType.seaMine) {
      throw ArgumentError("Can't make an estimation for this terrain type: $_type");
    }

    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      return MineFieldsEstimationResult(0, cellsPossibleToPlace: []);
    }

    final allAggressors = _metadata.getAllAggressive();
    final allCellsInDanger = allCellsPossibleToBuild.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allAggressors) {
        if (cellFromMap.hasAny(aggressor)) {
          return true;
        }
      }

      return false;
    });

    // We are not in danger right now? - do nothing
    if (allCellsInDanger.isEmpty) {
      return MineFieldsEstimationResult(0, cellsPossibleToPlace: []);
    }

    var allOurCells = _gameField.cells.count((c) {
      if (c.nation != _myNation) {
        return false;
      }

      if ((c.isLand && !_isLand) || (!c.isLand && _isLand)) {
        return false;
      }

      return true;
    });

    final resultWeight = (allCellsInDanger.length.toDouble() / allOurCells) * 10.0 / _correctionFactor;
    return MineFieldsEstimationResult(resultWeight, cellsPossibleToPlace: allCellsInDanger);
  }
}
