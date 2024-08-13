part of money_spending_phase_library;

class _FlameTroopersCellWithFactors {
  final GameFieldCellRead cell;

  final double unitPower;

  _FlameTroopersCellWithFactors({
    required this.cell,
    required this.unitPower,
  });
}

class _FlameTroopersEstimator implements Estimator<_SpecialStrikeEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _FlameTroopersEstimator({
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
      SpecialStrikeType.flameTroopers,
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

          return _FlameTroopersCellWithFactors(
            cell: cell,
            unitPower: UnitPowerEstimation.estimate(cell.activeUnit!),
          );
        })
        .where((e) => e != null)
        .toList(growable: false);

    if (cellsWithFactors.isEmpty) {
      return [];
    }

    return cellsWithFactors.map((c) => EstimationResult<_SpecialStrikeEstimationData>(
          weight: 1.0 + c!.unitPower,
          data: _SpecialStrikeEstimationData(
            cell: c.cell,
            type: SpecialStrikeType.flameTroopers,
          ),
        ));
  }
}
