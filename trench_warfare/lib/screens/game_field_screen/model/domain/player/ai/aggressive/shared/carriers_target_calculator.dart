part of aggressive_ai_shared_library;

class CarriersTargetCalculator {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  static const _pathIsTooLongFactor = 4;

  static const _pathIsTooDangerousFactor = 0.2;

  CarriersTargetCalculator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata;

  /// We should calculate all geometric (!) distances from each of my PCs (city or fabric)
  /// to each enemy PC
  /// Then we should take the minimum distance, so we'll get the basis for analysis
  /// (two PCs - mine and the rival one).
  /// If it is impossible to build a infantry path by land - we should build carriers
  /// If the path is N times longer than the distance - we should build carriers
  /// If M percent of the path is occupied by enemy armies/minefields - we should build carriers
  /// [return] the target cell or null if the target is not found
  GameFieldCellRead? getTarget() {
    final myEnemies = _metadata.getMyEnemies(_myNation);

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
      return null;
    }

    /// The land path is too long - we should build carriers
    if (path.length / minDistance >= _pathIsTooLongFactor) {
      return null;
    }

    final dangerousCellsQuantity = path.count((cell) =>
        cell.terrainModifier?.type == TerrainModifierType.landMine ||
        (cell.nation != _myNation && cell.units.isNotEmpty));

    /// The land path is too dangerous - we should build carriers
    if (dangerousCellsQuantity / path.length > _pathIsTooDangerousFactor) {
      return null;
    }

    return enemySelectedPcCell;
  }
}
