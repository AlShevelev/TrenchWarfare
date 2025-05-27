/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of money_spending_phase_library;

/// Should we place a mine field in general?
class _MineFieldsEstimator extends Estimator<_TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final TerrainModifierType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _weight = 3.0;

  _MineFieldsEstimator({
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
  Iterable<EstimationResult<_TerrainModifierEstimationData>> estimate() {
    if (_type != TerrainModifierType.landMine && _type != TerrainModifierType.seaMine) {
      throw ArgumentError("Can't make an estimation for this type of terrain modifier: $_type");
    }

    Logger.info('_MineFieldsEstimator [$_type]: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_MineFieldsEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getEnemies(_myNation);

    // Our rivals are nearby, but we are not
    final cellsPossibleToBuildExt = cellsPossibleToBuild.where((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (_type == TerrainModifierType.landMine) {
        if (cellFromMap.getLand(_myNation) != null) {
          return false;
        }
      } else {
        // TerrainModifierType.seaMine
        if (cellFromMap.getSea(_myNation) != null || cellFromMap.getCarrier(_myNation) != null) {
          return false;
        }
      }

      return allAggressors.any((a)  {
        if (_type == TerrainModifierType.landMine) {
          return cellFromMap.getLand(a) != null;
        } else {
          // TerrainModifierType.seaMine
          return cellFromMap.getSea(a) != null || cellFromMap.getCarrier(a) != null;
        }
      });
    }).toList(growable: false);

    if (cellsPossibleToBuildExt.isEmpty) {
      Logger.info('_MineFieldsEstimator: estimate() completed [cellsPossibleToBuildExt.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_MineFieldsEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsPossibleToBuildExt
        .map((c) => EstimationResult<_TerrainModifierEstimationData>(
              weight: _weight,
              data: _TerrainModifierEstimationData(
                cell: c,
                type: _type,
              ),
            ))
        .toList(growable: false);

    Logger.info('_MineFieldsEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }
}
