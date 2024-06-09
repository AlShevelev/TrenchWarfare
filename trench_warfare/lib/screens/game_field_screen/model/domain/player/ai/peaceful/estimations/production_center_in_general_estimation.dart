part of estimations;

class ProductionCenterInGeneralEstimationResult extends EstimationResult {
  final Iterable<GameFieldCellRead> cellsPossibleToBuild;

  ProductionCenterInGeneralEstimationResult(
    super.weight, {
    required this.cellsPossibleToBuild,
  });
}

/// Should we build production center on not in general?
class ProductionCenterInGeneralEstimator implements Estimator<ProductionCenterInGeneralEstimationResult> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final ProductionCenterType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type != ProductionCenterType.navalBase;

  double get _correctionFactor => _isLand ? 2.0 : 4.0;

  ProductionCenterInGeneralEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required ProductionCenterType type,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _type = type,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  ProductionCenterInGeneralEstimationResult estimate() {
    if (_type == ProductionCenterType.airField) {
      throw ArgumentError("Can't make an estimation for an air field");
    }

    final buildCalculator = ProductionCentersBuildCalculator(_gameField, _myNation);
    final allCells = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCells.isEmpty) {
      return ProductionCenterInGeneralEstimationResult(0, cellsPossibleToBuild: []);
    }

    final allAggressors = _metadata.getAllAggressive();
    final allSafeCells = allCells.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allAggressors) {
        if (cellFromMap.hasAny(aggressor)) {
          return false;
        }
      }

      return true;
    });

    // It's a dangerous time, we shouldn't build production centers in a moment
    if (allSafeCells.isEmpty) {
      return ProductionCenterInGeneralEstimationResult(0, cellsPossibleToBuild: []);
    }

    var allOurCells = 0;
    var allOurCellsWithPC = 0;

    for (final cell in _gameField.cells) {
      if ((cell.isLand && !_isLand) || (!cell.isLand && _isLand)) {
        continue;
      }

      if (cell.nation == _myNation) {
        allOurCells++;

        if (cell.productionCenter?.type == _type) {
          allOurCellsWithPC++;
        }
      }
    }

    final resultWeight = allOurCellsWithPC == 0
        ? 10.0
        : (math.sqrt(allOurCells.toDouble() / allOurCellsWithPC) - 1) / _correctionFactor;
    return ProductionCenterInGeneralEstimationResult(resultWeight, cellsPossibleToBuild: allSafeCells);
  }
}
