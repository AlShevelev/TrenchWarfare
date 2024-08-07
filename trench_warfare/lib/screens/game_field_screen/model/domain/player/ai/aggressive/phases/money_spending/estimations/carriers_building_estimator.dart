part of aggressive_player_ai;

class CarriersBuildingEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  CarriersBuildingEstimationData({required this.cell});
}

/// Should we hire a unit in general?
class CarriersBuildingEstimator implements Estimator<CarriersBuildingEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final MapMetadataRead _metadata;

  //bool get _isLand => _type.isLand;

  //double get _correctionFactor => _isLand ? 1.0 : 0.5;

  /// The maximum quantity of carriers you can get
  static const _maxCarries = 3;

  static const _pathIsTooLongFactor = 4;

  static const _pathIsTooDangerousFactor = 0.2;

  static const _defaultWeight = 100.0;

  CarriersBuildingEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata;

  @override
  Iterable<EstimationResult<CarriersBuildingEstimationData>> estimate() {
    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(UnitType.carrier, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    // check quantity
    final totalCarriers = _gameField.cells.map((c) {
      if (c.nation != _myNation || c.units.isEmpty) {
        return 0;
      }

      return c.units.count((u) => u.type == UnitType.carrier);
    }).sum;

    // We've got enough carriers for now
    if (totalCarriers >= _maxCarries) {
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    // It is not worth it - too complicated
    if (!shouldBuildByPath(allAggressors)) {
      return [];
    }

    return cellsPossibleToBuild
        .map((cell) => EstimationResult(
              weight: _defaultWeight,
              data: CarriersBuildingEstimationData(cell: cell),
            ))
        .toList(growable: false);
  }

  /// We should calculate all geometric (!) distances from each of my PCs (city or fabric)
  /// to each enemy PC
  /// Then we should take the minimum distance, so we'll get the basis for analysis
  /// (two PCs - mine and the rival one).
  /// If it is impossible to build a infantry path by land - we should build carriers
  /// If the path is N times longer than the distance - we should build carriers
  /// If M percent of the path is occupied by enemy armies/minefields - we should build carriers
  bool shouldBuildByPath(List<Nation> myEnemies) {
    final allMyPcCells = <GameFieldCellRead>[];
    final allEnemyPcCells = <GameFieldCellRead>[];

    // Collects all PCs
    for (final cell in _gameField.cells) {
      if (cell.productionCenter?.type == ProductionCenterType.city ||
          cell.productionCenter?.type == ProductionCenterType.factory) {
        if (cell.nation == _myNation) {
          allMyPcCells.add(cell);
        } else if (myEnemies.contains(cell.nation)) {
          allEnemyPcCells.add(cell);
        }
      }
    }

    var minDistance = 1000000.0;
    late GameFieldCellRead mySelectedPcCell, enemySelectedPcCell;

    // Calculates the nearest PCs
    for (final myPcCell in allMyPcCells) {
      for (final enemyPcCell in allEnemyPcCells) {
        final distance = _gameField.calculateDistance(myPcCell, enemyPcCell);

        if (distance < minDistance) {
          minDistance = distance;
          mySelectedPcCell = myPcCell;
          enemySelectedPcCell = enemyPcCell;
        }
      }
    }

    // Calculates a path between PCs by land for some infantry unit
    // (an infantry unit can move through all types of territory)
    final pathFacade = PathFacade(_gameField);
    final path = pathFacade.calculatePathForUnit(
      startCell: mySelectedPcCell,
      endCell: enemySelectedPcCell,
      calculatedUnit: Unit.byType(UnitType.infantry),
    );

    // The land path doesn't exist - we should build carriers
    if (path.isEmpty) {
      return true;
    }

    /// The land path is too long - we should build carriers
    if (path.length / minDistance >= _pathIsTooLongFactor) {
      return true;
    }

    final dangerousCellsQuantity = path.count((cell) =>
        cell.terrainModifier?.type == TerrainModifierType.landMine ||
        (cell.nation != _myNation && cell.units.isNotEmpty));

    /// The land path is too dangerous - we should build carriers
    if (dangerousCellsQuantity / path.length > _pathIsTooDangerousFactor) {
      return true;
    }

    return false;
  }
}
