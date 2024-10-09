part of money_spending_phase_library;

class _AirFieldEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  _AirFieldEstimationData({required this.cell});
}

/// Should we build production center on not in general?
class _AirFieldEstimator extends Estimator<_AirFieldEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _maxFractionCellWithPCs = 0.075;

  static const _type = ProductionCenterType.airField;

  _AirFieldEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_AirFieldEstimationData>> estimate() {
    Logger.info('_AirFieldEstimator: estimate() started', tag: 'MONEY_SPENDING');

    final buildCalculator = ProductionCentersBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      _type,
      _nationMoney.totalSum,
    );

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      Logger.info('_AirFieldEstimator: estimate() completed [allCellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final allEnemies = _metadata.getMyEnemies(_myNation);

    var allSafeCells = allCellsPossibleToBuild.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allEnemies) {
        if (cellFromMap.getCombined(aggressor) > cellFromMap.getCombined(_myNation)) {
          return false;
        }
      }

      return true;
    }).toList(growable: false);

    // It's a dangerous time, we shouldn't build production centers in a moment
    if (allSafeCells.isEmpty) {
      Logger.info('_AirFieldEstimator: estimate() completed [allSafeCells.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    var allOurCellsCount = 0;
    final List<GameFieldCellRead> allOurCellsWithPC = [];

    for (final cell in _gameField.cells) {
      if (!cell.isLand) {
        continue;
      }

      if (cell.nation == _myNation) {
        allOurCellsCount++;

        if (cell.productionCenter?.type == _type) {
          allOurCellsWithPC.add(cell);
        }
      }
    }

    Logger.info('_AirFieldEstimator: estimate() allOurCells are calculated', tag: 'MONEY_SPENDING');

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

    Logger.info('_AirFieldEstimator: estimate() ready to calculate weightedCells', tag: 'MONEY_SPENDING');
    final List<({GameFieldCellRead cell, double weight})> weightedCells = [];
    for (final cellCandidateToBuild in allSafeCells) {
      var cellWithEnemyUnitsTotal = 0;
      var enemyCellsTotal = 0;

      final battleRadius = cellCandidateToBuild.productionCenter == null
          ? GameConstants.flechettesRadius
          : GameConstants.airBombardmentRadius;

      // Calculates possible enemies inside a battle radius
      for (var i = 1; i <= battleRadius; i++) {
        // All enemy cells with units
        final allEnemyCellsAround = _gameField
            .findCellsAroundR(cellCandidateToBuild, radius: i)
            .where((c) => allEnemies.contains(c.nation))
            .toList(growable: false);

        enemyCellsTotal += allEnemyCellsAround.length;
        cellWithEnemyUnitsTotal += allEnemyCellsAround.where((c) => c.units.isNotEmpty).length;
      }

      final weight = enemyCellsTotal == 0 ? 0.0 : cellWithEnemyUnitsTotal / enemyCellsTotal;
      weightedCells.add((cell: cellCandidateToBuild, weight: weight));
    }

    Logger.info('_AirFieldEstimator: estimate() weightedCells are calculated', tag: 'MONEY_SPENDING');

    var baseResultWeight = allOurCellsWithPC.isEmpty
        ? 100.0
        : allOurCellsCount.toDouble() / allOurCellsWithPC.length;

    Logger.info('_AirFieldEstimator: estimate() ready to calculate a result', tag: 'MONEY_SPENDING');

    final result = weightedCells
        .where((c) => c.weight != 0)
        .map((c) => EstimationResult<_AirFieldEstimationData>(
              weight: (baseResultWeight * c.weight) + 1,
              data: _AirFieldEstimationData(
                cell: c.cell,
              ),
            ))
        .toList(growable: false);

    Logger.info('_AirFieldEstimator: the result is calculated', tag: 'MONEY_SPENDING');

    return result;
  }
}
