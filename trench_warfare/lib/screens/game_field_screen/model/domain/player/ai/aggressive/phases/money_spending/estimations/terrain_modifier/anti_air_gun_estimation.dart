part of aggressive_player_ai;

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
class AntiAirGunEstimator implements Estimator<TerrainModifierEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final MapMetadataRead _metadata;

  AntiAirGunEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<TerrainModifierEstimationData>> estimate() {
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.antiAirGun,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

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
      return [];
    }

    return cellsWithFactors.map((c) => EstimationResult<TerrainModifierEstimationData>(
          weight: 1.0 +
              _calculateWeight(c!.cell, ProductionCenterLevel.level1) * c.level1EnemyAirFieldsTotal +
              _calculateWeight(c.cell, ProductionCenterLevel.level2) * c.level2EnemyAirFieldsTotal,
          data: TerrainModifierEstimationData(
            cell: c.cell,
            type: TerrainModifierType.antiAirGun,
          ),
        ));
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
