part of peaceful_player_ai;

class UnitsEstimationData implements EstimationData {
  final GameFieldCellRead cell;

  final UnitType type;

  final double dangerousFactor;

  UnitsEstimationData({required this.cell, required this.type, required this.dangerousFactor});
}

/// Should we hire a unit in general?
class UnitsEstimator implements Estimator<UnitsEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final UnitType _type;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  bool get _isLand => _type.isLand;

  double get _correctionFactor => _isLand ? 1.0 : 2.0;

  UnitsEstimator({
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
  Iterable<EstimationResult<UnitsEstimationData>> estimate() {
    if (_type == UnitType.carrier) {
      throw ArgumentError("Can't make an estimation for this type of unit: $_type");
    }

    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final allCellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (allCellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getAllAggressive();
    final allCellsInDanger = allCellsPossibleToBuild.where((c) {
      final cellFromMap = _influenceMap.getItem(c.row, c.col);

      for (final aggressor in allAggressors) {
        if (cellFromMap.hasAny(aggressor)) {
          return true;
        }
      }

      return false;
    });

    // We are not in danger right now? - do nothing
    if (allCellsInDanger.isEmpty) {
      return [];
    }

    var allOurCells = _gameField.cells.count((c) {
      if (c.nation != _myNation) {
        return false;
      }

      if ((c.isLand && !_isLand) || (!c.isLand && _isLand)) {
        return false;
      }

      return true;
    });

    final resultWeight = (allCellsInDanger.length.toDouble() / allOurCells) * 15.0 / _correctionFactor;

    return allCellsInDanger
        .map((c) => EstimationResult<UnitsEstimationData>(
              weight: resultWeight,
              data: UnitsEstimationData(
                cell: c,
                type: _type,
                dangerousFactor: _calculateDangerousFactor(c, allAggressors),
              ),
            ))
        .toList(growable: false);
  }

  double _calculateDangerousFactor(GameFieldCellRead cell, List<Nation> allAggressors) {
    final mapCell = _influenceMap.getItem(cell.row, cell.col);
    return allAggressors.map((a) => mapCell.getCombined(a)).sum();
  }
}
