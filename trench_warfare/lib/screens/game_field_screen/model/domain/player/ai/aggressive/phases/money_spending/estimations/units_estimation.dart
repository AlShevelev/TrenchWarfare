part of aggressive_player_ai;

/*
class UnitsEstimationResult extends EstimationResult {
  final Iterable<GameFieldCellRead> cellsPossibleToHire;

  UnitsEstimationResult(
      super.weight, {
        required this.cellsPossibleToHire,
      });
}
*/

/// Should we hire a unit in general?
/*
class UnitsEstimator implements Estimator<UnitsEstimationResult> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final UnitType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type.isLand;

  double get _correctionFactor => _isLand ? 1.0 : 2.0;

  UnitsEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required UnitType type,
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
  UnitsEstimationResult estimate() {
    if (_type == UnitType.carrier) {
      throw ArgumentError("Can't make an estimation for this type of unit: $_type");
    }

    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      return UnitsEstimationResult(0, cellsPossibleToHire: []);
    }

    final allAggressors = _metadata.getAllAggressive().where((a) => a != _myNation).toList(growable: true);
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
      return UnitsEstimationResult(0, cellsPossibleToHire: []);
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

    final resultWeight = (allCellsInDanger.length.toDouble() / allOurCells) * 15.0 / _correctionFactor;
    return UnitsEstimationResult(resultWeight, cellsPossibleToHire: allCellsInDanger);
  }
}
*/

/*
Must not be so depend on dangerous factor (but the dungerous cells must have priority).
The closer to the front the better
The stronger the better
*/
