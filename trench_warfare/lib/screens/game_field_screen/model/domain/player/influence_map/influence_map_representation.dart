part of influence_map;

abstract interface class InfluenceMapRepresentationRead {
  InfluenceMapItemRead getItem(int row, int col);
}

class InfluenceMapRepresentation implements InfluenceMapRepresentationRead {
  late final InfluenceMap _map;

  late final PathFacade _pathFacade;

  late final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  InfluenceMapRepresentation({
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _myNation = myNation,
        _metadata = metadata;

  Future<void> calculateFull(GameFieldRead gameField) async {
    _gameField = gameField;

    _pathFacade = PathFacade(_gameField, _myNation, _metadata);

    _map = InfluenceMap(
      gameField.cells.map((e) => InfluenceMapItem(row: e.row, col: e.col)).toList(),
      rows: gameField.rows,
      cols: gameField.cols,
    );

    for (var i = 0; i < gameField.rows; i++) {
      for (var j = 0; j < gameField.cols; j++) {
        final cell = gameField.getCell(i, j);

        if (cell.units.isEmpty) {
          continue;
        }

        for (final unit in cell.units) {
          addUnit(unit, cell.nation!, cell);
        }
      }
    }
  }

  @override
  InfluenceMapItemRead getItem(int row, int col) => _map.getCell(row, col);

  void addUnit(Unit unit, Nation nation, GameFieldCellRead gameCell) =>
      _processUnit(unit, nation, gameCell, powerFactor: 1);

  void removeUnit(Unit unit, Nation nation, GameFieldCellRead gameCell) =>
      _processUnit(unit, nation, gameCell, powerFactor: -1);

  void _processUnit(Unit unit, Nation nation, GameFieldCellRead gameCell, {required int powerFactor}) {
    final mapItem = _map.getCell(gameCell.row, gameCell.col);

    final processedUnit = unit is Carrier ? Carrier.copy(unit) : Unit.copy(unit);

    processedUnit.setMovementPoints(processedUnit.maxMovementPoints);

    if (UnitBoosterBuildCalculator.canBuildForUnit(processedUnit, UnitBoost.transport)) {
      processedUnit.setBoost(UnitBoost.transport);
    }

    final basePower = UnitPowerEstimation.estimate(processedUnit);

    _updateMapItem(mapItem: mapItem, unit: processedUnit, power: basePower * powerFactor, nation: nation);

    var radius = 1;
    var cellsAround = _gameField.findCellsAroundR(gameCell, radius: radius);

    var maxPathLen = -1;
    final List<Tuple2<int, InfluenceMapItem>> mapItemsForUnit = [];

    // All possible paths calculation
    while (cellsAround.isNotEmpty) {
      var anyCellReached = false;

      for (final cellAround in cellsAround) {
        final pathLen = _pathFacade.canReach(processedUnit, startCell: gameCell, endCell: cellAround);

        if (pathLen != null) {
          anyCellReached = true;

          if (pathLen > maxPathLen) {
            maxPathLen = pathLen;
          }

          mapItemsForUnit.add(Tuple2(pathLen, _map.getCell(cellAround.row, cellAround.col)));
        }
      }

      if (!anyCellReached) {
        break;
      }

      cellsAround = _gameField.findCellsAroundR(gameCell, radius: ++radius);
    }

    // Calculates power for all the cells with reachable path
    for (final mapItemForUnit in mapItemsForUnit) {
      _updateMapItem(
        mapItem: mapItemForUnit.item2,
        unit: processedUnit,
        power: _calculateEstimation(
              maxPower: basePower,
              pathLen: mapItemForUnit.item1,
              maxPathLen: maxPathLen,
            ) *
            powerFactor,
        nation: nation,
      );
    }
  }

  void _updateMapItem(
      {required InfluenceMapItem mapItem,
      required Unit unit,
      required double power,
      required Nation nation}) {
    if (unit is Carrier) {
      mapItem.updateCarrier(power, nation);
    } else if (unit.isShip) {
      mapItem.updateSea(power, nation);
    } else {
      mapItem.updateLand(power, nation);
    }
  }

  double _calculateEstimation({required double maxPower, required int pathLen, required int maxPathLen}) =>
      maxPower - (maxPower / maxPathLen) * (pathLen - 1); // A simple linear
}
