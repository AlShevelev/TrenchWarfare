part of influence_map;

abstract interface class InfluenceMapRepresentationRead {
  InfluenceMapItemRead getItem(int row, int col);
}

class InfluenceMapRepresentation implements InfluenceMapRepresentationRead {
  late final InfluenceMap _map;

  Future<void> calculate(GameFieldRead gameField) async {
    _map = InfluenceMap(
      gameField.cells.map((e) => InfluenceMapItem(row: e.row, col: e.col)).toList(),
      rows: gameField.rows,
      cols: gameField.cols,
    );

    final pathFacade = PathFacade(gameField);

    for (var i = 0; i < gameField.rows; i++) {
      for (var j = 0; j < gameField.cols; j++) {
        final gameCell = gameField.getCell(i, j);

        if (gameCell.units.isEmpty) {
          continue;
        }

        final mapItem = _map.getCell(i, j);
        final nation = gameCell.nation!;

        for (final unit in gameCell.units) {
          final processedUnit = unit is Carrier ? Carrier.copy(unit) : Unit.copy(unit);
          processedUnit.setMovementPoints(processedUnit.maxMovementPoints);

          final basePower = UnitPowerEstimation.estimate(processedUnit);

          _updateMapItem(mapItem: mapItem, unit: processedUnit, power: basePower, nation: nation);

          var radius = 1;
          var cellsAround = gameField.findCellsAroundR(gameCell, radius: radius);

          var maxPathLen = -1;
          final List<Tuple2<int, InfluenceMapItem>> mapItemsForUnit = [];

          // All possible paths calculation
          while (cellsAround.isNotEmpty) {
            var anyCellReached = false;

            for (final cellAround in cellsAround) {
              final pathLen = pathFacade.canReach(processedUnit, startCell: gameCell, endCell: cellAround);

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

            cellsAround = gameField.findCellsAroundR(gameCell, radius: ++radius);
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
              ),
              nation: nation,
            );
          }
        }
      }
    }
  }

  @override
  InfluenceMapItemRead getItem(int row, int col) => _map.getCell(row, col);

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
