part of money_spending_phase_library;

class _ProductionCenterEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final ProductionCenterType type;

  _ProductionCenterEstimationData({required this.cell, required this.type});
}

/// Should we build production center on not in general?
class _ProductionCenterEstimator extends Estimator<_ProductionCenterEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final ProductionCenterType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type != ProductionCenterType.navalBase;

  double get _correctionFactor => switch (_type) {
        ProductionCenterType.navalBase => 4.0,
        ProductionCenterType.city => 2.0,
        ProductionCenterType.factory => 2.0,
        _ => 0.0,
      };

  double get _maxFractionCellWithPCs => switch (_type) {
        ProductionCenterType.navalBase => 0.05,
        ProductionCenterType.city => 0.1,
        ProductionCenterType.factory => 0.1,
        _ => 0.0,
  };

  _ProductionCenterEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
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
  Iterable<EstimationResult<_ProductionCenterEstimationData>> estimate() {
    Logger.info('_ProductionCenterEstimator: estimate() started', tag: 'MONEY_SPENDING');

    if (_type == ProductionCenterType.airField) {
      throw UnsupportedError('This type of production center is not supported: $_type');
    }

    final buildCalculator = ProductionCentersBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney.totalSum);

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      Logger.info('_ProductionCenterEstimator: estimate() completed [allCellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    var allSafeCells = allCellsPossibleToBuild.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allAggressors) {
        if (cellFromMap.getCombined(aggressor) > cellFromMap.getCombined(_myNation)) {
          return false;
        }
      }

      return true;
    }).toList(growable: false);

    // It's a dangerous time, we shouldn't build production centers in a moment
    if (allSafeCells.isEmpty) {
      Logger.info('_ProductionCenterEstimator [$_type]: estimate() completed [allSafeCells.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
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
    Logger.info('_ProductionCenterEstimator: estimate() allOurCells are calculated', tag: 'MONEY_SPENDING');

    // We don't need too many production centers.
    if (allOurCellsWithPC.length.toDouble() / allOurCellsCount > _maxFractionCellWithPCs) {
      final pcWithoutMaxLevel = allOurCellsWithPC
          .where((c) =>
              c.productionCenter!.level != ProductionCenter.getMaxLevel(c.productionCenter!.type) &&
              allSafeCells.contains(c))
          .toList(growable: false);

      // All production centers are upgraded - that's all
      if (pcWithoutMaxLevel.isEmpty) {
        return [];
      } else {
        allSafeCells = pcWithoutMaxLevel;
      }
    }

    var resultWeight = allOurCellsWithPC.isEmpty
        ? 100.0
        : ((math.sqrt(allOurCellsCount.toDouble() / allOurCellsWithPC.length) - 1) / _correctionFactor);

    resultWeight *= switch (_type) {
      ProductionCenterType.city => getCityBuildBalancedFactor(_nationMoney),
      ProductionCenterType.factory => getFactoryBuildBalancedFactor(_nationMoney),
      _ => 1
    };

    resultWeight += 1;

    Logger.info('_ProductionCenterEstimator: estimate() ready to calculate a result', tag: 'MONEY_SPENDING');

    final result = allSafeCells
        .map((c) => EstimationResult<_ProductionCenterEstimationData>(
              weight: resultWeight,
              data: _ProductionCenterEstimationData(
                cell: c,
                type: _type,
              ),
            ))
        .toList(growable: false);

    Logger.info('_ProductionCenterEstimator: estimate() result is calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
