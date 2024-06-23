part of aggressive_player_ai;

class ProductionCenterEstimationResult extends EstimationResult {
  final Iterable<GameFieldCellRead> cellsPossibleToBuild;

  ProductionCenterEstimationResult(
      super.weight, {
        required this.cellsPossibleToBuild,
      });
}

/// Should we build production center on not in general?
class ProductionCenterEstimator implements Estimator<ProductionCenterEstimationResult> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final ProductionCenterType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type != ProductionCenterType.navalBase;

  double get _correctionFactor => switch(_type) {
    ProductionCenterType.navalBase =>  4.0,
    ProductionCenterType.city =>  2.0,
    ProductionCenterType.factory =>  2.0,
    ProductionCenterType.airField =>  3.0,
  };

  double get _maxFractionCellWithPCs => switch(_type) {
    ProductionCenterType.navalBase =>  0.05,
    ProductionCenterType.city =>  0.1,
    ProductionCenterType.factory =>  0.1,
    ProductionCenterType.airField =>  0.075,
  };

  ProductionCenterEstimator({
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
  ProductionCenterEstimationResult estimate() {
    final buildCalculator = ProductionCentersBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      return ProductionCenterEstimationResult(0, cellsPossibleToBuild: []);
    }

    final allAggressors = _metadata.getAllAggressive().where((a) => a != _myNation).toList(growable: true);
    var allSafeCells = allCellsPossibleToBuild.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allAggressors) {
        if (cellFromMap.getCombined(aggressor) >  cellFromMap.getCombined(_myNation)) {
          return false;
        }
      }

      return true;
    }).toList(growable: false);

    // It's a dangerous time, we shouldn't build production centers in a moment
    if (allSafeCells.isEmpty) {
      return ProductionCenterEstimationResult(0, cellsPossibleToBuild: []);
    }

    var allOurCellsCount = 0;
    final List<GameFieldCellRead> allOurCellsWithPC = [];

    for (final cell in _gameField.cells) {
      if ((cell.isLand && !_isLand) || (!cell.isLand && _isLand)) {
        continue;
      }

      if (cell.nation == _myNation) {
        allOurCellsCount++;

        if (cell.productionCenter?.type == _type) {
          allOurCellsWithPC.add(cell);
        }
      }
    }

    // We don't need too many production centers.
    if (allOurCellsWithPC.length.toDouble() / allOurCellsCount > _maxFractionCellWithPCs) {
      final pcWithoutMaxLevel = allOurCellsWithPC
          .where((c) =>
      c.productionCenter!.level != ProductionCenter.getMaxLevel(c.productionCenter!.type) &&
          allSafeCells.contains(c))
          .toList(growable: false);

      // All production centers are upgraded - that's all
      if (pcWithoutMaxLevel.isEmpty) {
        return ProductionCenterEstimationResult(0, cellsPossibleToBuild: []);
      } else {
        allSafeCells = pcWithoutMaxLevel;
      }
    }

    final resultWeight = allOurCellsWithPC.isEmpty
        ? 10.0
        : (math.sqrt(allOurCellsCount.toDouble() / allOurCellsWithPC.length) - 1) / _correctionFactor;
    return ProductionCenterEstimationResult(resultWeight, cellsPossibleToBuild: allSafeCells);
  }
}
