part of money_spending_phase_library;

class _BarbedWireCellWithFactors {
  final GameFieldCellRead cell;

  final int cellAroundTotal;

  final int properCellAroundTotal;

  _BarbedWireCellWithFactors({
    required this.cell,
    required this.cellAroundTotal,
    required this.properCellAroundTotal,
  });
}

/// Should we place a barbed wire in general?
class _BarbedWireEstimator extends Estimator<_TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _weightCorrectionFactor = 4.0;

  _BarbedWireEstimator({
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
  Iterable<EstimationResult<_TerrainModifierEstimationData>> estimate() {
    Logger.info('_BarbedWire: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.barbedWire,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_BarbedWire: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
            return null;
          }

          if (cell.units.isEmpty) {
            return null;
          }

          final cellsAround = List<GameFieldCellRead>.from(_gameField.findCellsAround(cell))
            ..addAll(_gameField.findCellsAroundR(cell, radius: 2))
            ..addAll(_gameField.findCellsAroundR(cell, radius: 3));

          final properCellAroundTotal = cellsAround.count((c) =>
              c.nation != null &&
              allAggressors.contains(c.nation) &&
              (c.units.any((u) => u.type == UnitType.artillery) ||
                  c.units.any((u) => u.type == UnitType.tank)));

          return _BarbedWireCellWithFactors(
            cell: cell,
            cellAroundTotal: cellsAround.length,
            properCellAroundTotal: properCellAroundTotal,
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_BarbedWire: estimate() completed [cellsWithFactors.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_BarbedWire: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors.map((c) => EstimationResult<_TerrainModifierEstimationData>(
          weight: 1.0 + (c!.properCellAroundTotal / c.cellAroundTotal) * _weightCorrectionFactor,
          data: _TerrainModifierEstimationData(
            cell: c.cell,
            type: TerrainModifierType.barbedWire,
          ),
        ));

    Logger.info('_BarbedWire: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
