part of aggressive_player_ai;

class BarbedWireEstimationData {
  final GameFieldCellRead cell;

  final TerrainModifierType type;

  BarbedWireEstimationData({required this.cell, required this.type});
}

/// Should we place a barbed wire in general?
class BarbedWireEstimator implements Estimator<BarbedWireEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  BarbedWireEstimator({
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
  Iterable<EstimationResult<BarbedWireEstimationData>> estimate() {
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      TerrainModifierType.barbedWire,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getAllAggressive().where((a) => a != _myNation).toList(growable: true);

    final cellsPossibleToBuildExt = cellsPossibleToBuild.where((cell) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
        return false;
      }

      if (cell.units.isEmpty) {
        return false;
      }

      final cellsAround = List<GameFieldCellRead>.from(_gameField.findCellsAround(cell))
        ..addAll(_gameField.findCellsAroundR(cell, radius: 2))
        ..addAll(_gameField.findCellsAroundR(cell, radius: 3));

      return cellsAround
          .where((c) =>
              c.nation != null &&
              allAggressors.contains(c.nation) &&
              (c.units.any((u) => u.type == UnitType.artillery) ||
                  c.units.any((u) => u.type == UnitType.tank)))
          .isNotEmpty;
    }).toList(growable: false);

    if (cellsPossibleToBuildExt.isEmpty) {
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<BarbedWireEstimationData>(
          weight: 2.0,
          data: BarbedWireEstimationData(
            cell: c,
            type: TerrainModifierType.barbedWire,
          ),
        ));
  }
}
