part of money_spending_phase_library;

class _AirBombardmentCellWithFactors {
  final GameFieldCellRead cell;

  final double unitsSumPower;

  final int unitsQuantity;

  _AirBombardmentCellWithFactors({
    required this.cell,
    required this.unitsSumPower,
    required this.unitsQuantity,
  });
}

class _AirBombardmentEstimator implements Estimator<_SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _AirBombardmentEstimator({
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
  Iterable<EstimationResult<_SpecialStrikeEstimationData>> estimate() {
    final buildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _metadata);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      SpecialStrikeType.airBombardment,
      _nationMoney,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (!cellFromMap.hasAny(_myNation)) {
            return null;
          }

          return _AirBombardmentCellWithFactors(
            cell: cell,
            unitsQuantity: cell.units.length,
            unitsSumPower: cell.units.map((u) => UnitPowerEstimation.estimate(u)).sum,
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      return [];
    }

    return cellsWithFactors.map((c) => EstimationResult<_SpecialStrikeEstimationData>(
          weight: 1.0 + c!.unitsQuantity * c.unitsSumPower,
          data: _SpecialStrikeEstimationData(
            cell: c.cell,
            type: SpecialStrikeType.airBombardment,
          ),
        ));
  }
}
