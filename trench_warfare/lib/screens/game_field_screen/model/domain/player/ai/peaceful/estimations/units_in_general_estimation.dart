part of estimations;

class UnitsInGeneralEstimationResult extends EstimationResult {
  final Iterable<GameFieldCellRead> cellsPossibleToHire;

  UnitsInGeneralEstimationResult(
      super.weight, {
        required this.cellsPossibleToHire,
      });
}

/// Should we place mine fields in general?
class UnitsInGeneralEstimator implements Estimator<UnitsInGeneralEstimationResult> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final UnitType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type.isLand;

  double get _correctionFactor => _isLand ? 1.0 : 2.0;

  UnitsInGeneralEstimator({
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
  UnitsInGeneralEstimationResult estimate() {
    if (_type == UnitType.carrier) {
      throw ArgumentError("Can't make an estimation for this type of unit: $_type");
    }

    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final allCells = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCells.isEmpty) {
      return UnitsInGeneralEstimationResult(0, cellsPossibleToHire: []);
    }

    final allAggressors = _metadata.getAllAggressive();
    final allCellsInDanger = allCells.where((c) {
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
      return UnitsInGeneralEstimationResult(0, cellsPossibleToHire: []);
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
    return UnitsInGeneralEstimationResult(resultWeight, cellsPossibleToHire: allCellsInDanger);
  }
}
