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

class _UnitsBuildingEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final UnitType type;

  _UnitsBuildingEstimationData({required this.cell, required this.type});
}

class _CellWithDangerFactor {
  final GameFieldCellRead cell;

  final double dangerFactor;

  final double? minDistanceToEnemyUnit;

  final double nearestEnemyPcPower;

  final double? minDistanceToEnemyPc;

  _CellWithDangerFactor({
    required this.cell,
    required this.dangerFactor,
    required this.minDistanceToEnemyUnit,
    required this.nearestEnemyPcPower,
    required this.minDistanceToEnemyPc,
  });
}

/// Should we hire a unit in general?
class _UnitsBuildingEstimator extends Estimator<_UnitsBuildingEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final UnitType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type.isLand;

  double get _correctionFactor => _isLand ? 1.0 : 0.5;

  _UnitsBuildingEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required UnitType type,
    required MoneyStorageRead nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _type = type,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<_UnitsBuildingEstimationData>> estimate() {
    if (_type == UnitType.carrier) {
      throw ArgumentError("Can't make an estimation for this type of unit: $_type");
    }

    Logger.info('_UnitsBuildingEstimator [$_type]: estimate() started', tag: 'MONEY_SPENDING');
    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney.totalSum);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      Logger.info('_UnitsBuildingEstimator: estimate() completed [cellsPossibleToBuild.isEmpty]', tag: 'MONEY_SPENDING');
      return [];
    }

    final allAggressors = _metadata.getEnemies(_myNation);

    final allCellsWithEnemyUnits = _getAllCellsWithEnemyUnits(allAggressors);

    final allCellsWithEnemyPc = _getAllCellsWithEnemyPc(allAggressors);

    final cellsPossibleToBuildExt = cellsPossibleToBuild.map((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      // Calculates total danger level
      double totalDanger = 0;
      for (final aggressor in allAggressors) {
        totalDanger += cellFromMap.getCombined(aggressor);
      }

      // Calculate min distance to enemy
      var minDistanceUnit = allCellsWithEnemyUnits.isEmpty ? null : _gameField.cells.length.toDouble();
      for (final cellWithEnemyUnit in allCellsWithEnemyUnits) {
        final distance = _gameField.calculateDistance(cell, cellWithEnemyUnit);
        if (distance < minDistanceUnit!) {
          minDistanceUnit = distance;
        }
      }

      // Calculate min distance and power of nearest PC
      var minDistancePc = allCellsWithEnemyPc.isEmpty ? null : _gameField.cells.length.toDouble();
      var nearestPcPower = 0.0;
      for (final cellWithEnemyPc in allCellsWithEnemyPc) {
        final distance = _gameField.calculateDistance(cell, cellWithEnemyPc);
        if (distance < minDistancePc!) {
          minDistancePc = distance;
          nearestPcPower = _estimatePcPower(cellWithEnemyPc.productionCenter!);
        }
      }

      return _CellWithDangerFactor(
        cell: cell,
        dangerFactor: totalDanger,
        minDistanceToEnemyUnit: minDistanceUnit,
        minDistanceToEnemyPc: minDistancePc,
        nearestEnemyPcPower: nearestPcPower,
      );
    }).toList(growable: false);

    Logger.info('_UnitsBuildingEstimator: _CellWithDangerFactor[] calculated', tag: 'MONEY_SPENDING');
    final unitPower = UnitPowerEstimation.estimate(Unit.byType(_type));

    final maxDistance = math.sqrt(math.pow(_gameField.rows, 2) + math.pow(_gameField.cols, 2));

    Logger.info('_UnitsBuildingEstimator: ready to calculate a result', tag: 'MONEY_SPENDING');
    final result = cellsPossibleToBuildExt.map((cell) {
      final enemyUnitsWeight = InGameMath.log10(
        unitPower *
            cell.dangerFactor *
            (maxDistance - (cell.minDistanceToEnemyUnit ?? maxDistance)) *
            _correctionFactor,
      );

      final nearestEnemyPcWeight = InGameMath.log10(
        cell.nearestEnemyPcPower * (maxDistance - (cell.minDistanceToEnemyPc ?? maxDistance))
      );

      final weight = 1 + (enemyUnitsWeight + nearestEnemyPcWeight) * getMoneyWeightFactor(_nationMoney);

      return EstimationResult<_UnitsBuildingEstimationData>(
        weight: weight,
        data: _UnitsBuildingEstimationData(
          cell: cell.cell,
          type: _type,
        ),
      );
    }).toList(growable: false);

    Logger.info('_UnitsBuildingEstimator: the result are calculated', tag: 'MONEY_SPENDING');
    return result;
  }

  Iterable<GameFieldCellRead> _getAllCellsWithEnemyUnits(Iterable<Nation> allAggressors) =>
      _gameField.cells.where((gameFieldCell) {
        if (gameFieldCell.units.isEmpty) {
          return false;
        }

        if (gameFieldCell.nation == null ||
            gameFieldCell.nation == _myNation ||
            !allAggressors.contains(gameFieldCell.nation)) {
          return false;
        }

        return gameFieldCell.units.any((u) => u.type.isLand == _type.isLand);
      }).toList(growable: false);

  Iterable<GameFieldCellRead> _getAllCellsWithEnemyPc(Iterable<Nation> allAggressors) =>
      _gameField.cells.where((gameFieldCell) {
        if (gameFieldCell.productionCenter == null) {
          return false;
        }

        if (gameFieldCell.nation == null ||
            gameFieldCell.nation == _myNation ||
            !allAggressors.contains(gameFieldCell.nation)) {
          return false;
        }

        return gameFieldCell.productionCenter?.isLand ==  _type.isLand;
      }).toList(growable: false);

  double _estimatePcPower(ProductionCenter productionCenter) =>
      productionCenter.level.getWeight() * switch (productionCenter.type) {
      ProductionCenterType.city => 2.0,
      ProductionCenterType.factory => 2.0,
      ProductionCenterType.navalBase => 1.0,
      ProductionCenterType.airField => 1.0,
    };
}
