part of aggressive_player_ai;

class UnitsBuildingEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final UnitType type;

  UnitsBuildingEstimationData({required this.cell, required this.type});
}

class _CellWithDangerFactor {
  final GameFieldCellRead cell;

  final double dangerFactor;

  final double? minDistanceToEnemyUnit;

  _CellWithDangerFactor({
    required this.cell,
    required this.dangerFactor,
    required this.minDistanceToEnemyUnit,
  });
}

/// Should we hire a unit in general?
class UnitsBuildingEstimator implements Estimator<UnitsBuildingEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final UnitType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type.isLand;

  double get _correctionFactor => _isLand ? 1.0 : 0.5;

  UnitsBuildingEstimator({
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
  Iterable<EstimationResult<UnitsBuildingEstimationData>> estimate() {
    if (_type == UnitType.carrier) {
      throw ArgumentError("Can't make an estimation for this type of unit: $_type");
    }

    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final allCellsWithEnemies = _getAllCellsWithEnemies(allAggressors);

    final cellsPossibleToBuildExt = cellsPossibleToBuild.map((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      // Calculates total danger level
      double totalDanger = 0;
      for (final aggressor in allAggressors) {
        totalDanger += cellFromMap.getCombined(aggressor);
      }

      // Calculate min distance to enemy
      var minDistance = allCellsWithEnemies.isEmpty ? null : _gameField.cells.length.toDouble();
      for (final cellWithEnemy in allCellsWithEnemies) {
        final distance = _gameField.calculateDistance(cell, cellWithEnemy);
        if (distance < minDistance!) {
          minDistance = distance;
        }
      }

      return _CellWithDangerFactor(
        cell: cell,
        dangerFactor: totalDanger,
        minDistanceToEnemyUnit: minDistance,
      );
    }).toList(growable: false);

    final unitPower = UnitPowerEstimation.estimate(Unit.byType(_type));

    final maxDistance = math.sqrt(math.pow(_gameField.rows, 2) + math.pow(_gameField.cols, 2));

    return cellsPossibleToBuildExt.map((cell) {
      final weight = 1 +
          log10(
            unitPower *
                cell.dangerFactor *
                (maxDistance - (cell.minDistanceToEnemyUnit ?? maxDistance)) *
                _correctionFactor,
          );

      return EstimationResult<UnitsBuildingEstimationData>(
        weight: weight,
        data: UnitsBuildingEstimationData(
          cell: cell.cell,
          type: _type,
        ),
      );
    }).toList(growable: false);
  }

  Iterable<GameFieldCellRead> _getAllCellsWithEnemies(Iterable<Nation> allAggressors) =>
      _gameField.cells.where((gameFieldCell) {
        if (gameFieldCell.units.isEmpty) {
          return false;
        }

        if (gameFieldCell.nation == null ||
            gameFieldCell.nation == _myNation ||
            !allAggressors.contains(gameFieldCell.nation)) {
          return false;
        }

        return gameFieldCell.units.any((u) => u.type != UnitType.carrier && u.type.isLand == _type.isLand);
      }).toList(growable: false);
}
