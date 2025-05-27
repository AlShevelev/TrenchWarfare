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

class _AntiAirGunCellWithFactors {
  final GameFieldCellRead cell;

  final int level1EnemyAirFieldsTotal;

  final int level2EnemyAirFieldsTotal;

  _AntiAirGunCellWithFactors({
    required this.cell,
    required this.level1EnemyAirFieldsTotal,
    required this.level2EnemyAirFieldsTotal,
  });
}

/// Should we place an anti air gun in general?
class _AntiAirGunEstimator extends Estimator<_TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final MapMetadataRead _metadata;

  _AntiAirGunEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_TerrainModifierEstimationData>> estimate() {
    Logger.info('_AntiAirGunEstimator: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.antiAirGun,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_AntiAirGunEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getEnemies(_myNation);

    final allAirfieldCells = _gameField.cells.where((c) {
      if (c.nation == null || !allAggressors.contains(c.nation)) {
        return false;
      }

      return c.productionCenter?.type == ProductionCenterType.airField;
    });

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          if (cell.units.isEmpty) {
            return null;
          }

          var level1EnemyAirFieldsTotal = 0;
          var level2EnemyAirFieldsTotal = 0;

          for (final airFieldCell in allAirfieldCells) {
            if (airFieldCell.productionCenter?.level == ProductionCenterLevel.level1) {
              if (_gameField.calculateDistance(cell, airFieldCell) <= GameConstants.flechettesRadius) {
                level1EnemyAirFieldsTotal++;
              }
            }

            if (airFieldCell.productionCenter?.level == ProductionCenterLevel.level2) {
              if (_gameField.calculateDistance(cell, airFieldCell) <= GameConstants.airBombardmentRadius) {
                level2EnemyAirFieldsTotal++;
              }
            }
          }

          if (level1EnemyAirFieldsTotal == 0 && level2EnemyAirFieldsTotal == 0) {
            return null;
          }

          return _AntiAirGunCellWithFactors(
            cell: cell,
            level1EnemyAirFieldsTotal: level1EnemyAirFieldsTotal,
            level2EnemyAirFieldsTotal: level2EnemyAirFieldsTotal,
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      Logger.info('_AntiAirGunEstimator: estimate() completed [cellsWithFactors.isEmpty]',
          tag: 'MONEY_SPENDING');
      return [];
    }

    Logger.info('_AntiAirGunEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsWithFactors
        .map((c) => EstimationResult<_TerrainModifierEstimationData>(
              weight: 1.0 +
                  _calculateWeight(c!.cell, ProductionCenterLevel.level1) * c.level1EnemyAirFieldsTotal +
                  _calculateWeight(c.cell, ProductionCenterLevel.level2) * c.level2EnemyAirFieldsTotal,
              data: _TerrainModifierEstimationData(
                cell: c.cell,
                type: TerrainModifierType.antiAirGun,
              ),
            ))
        .toList(growable: false);

    Logger.info('_AntiAirGunEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }

  double _calculateWeight(GameFieldCellRead cell, ProductionCenterLevel level) {
    if (level == ProductionCenterLevel.level1) {
      return 0.15 * cell.units.count((u) => !u.isMechanical);
    }

    if (level == ProductionCenterLevel.level2) {
      return 0.25 * cell.units.length;
    }

    return 0;
  }
}
