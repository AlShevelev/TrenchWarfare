part of aggressive_player_ai;

class _PropagandaCellWithFactors {
  final GameFieldCellRead cell;

  final double unitPower;

  _PropagandaCellWithFactors({
    required this.cell,
    required this.unitPower,
  });
}

class PropagandaEstimator implements Estimator<SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  PropagandaEstimator({
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
  Iterable<EstimationResult<SpecialStrikeEstimationData>> estimate() {
    final buildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _metadata);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(
      SpecialStrikeType.propaganda,
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

      return _PropagandaCellWithFactors(
        cell: cell,
        unitPower: UnitPowerEstimation.estimate(cell.activeUnit!),
      );
    })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      return [];
    }

    return cellsWithFactors.map((c) => EstimationResult<SpecialStrikeEstimationData>(
      weight: 1.0 + c!.unitPower,
      data: SpecialStrikeEstimationData(
        cell: c.cell,
        type: SpecialStrikeType.propaganda,
      ),
    ));
  }
}