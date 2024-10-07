part of money_spending_phase_library;

class _GasAttackCellWithFactors {
  final GameFieldCellRead cell;

  final double unitsSumPower;

  final int unitsQuantity;

  _GasAttackCellWithFactors({
    required this.cell,
    required this.unitsSumPower,
    required this.unitsQuantity,
  });
}

class _GasAttackEstimator extends Estimator<_SpecialStrikeEstimationData> {
  static const _correctionFactor = 1.5;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  _GasAttackEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
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
      SpecialStrikeType.gasAttack,
      _nationMoney.totalSum,
    );

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final cellsWithFactors = cellsPossibleToBuild
        .map((cell) {
          final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

          if (cellFromMap.hasAny(_myNation)) {
            return null;
          }

          return _GasAttackCellWithFactors(
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
          weight: 1.0 +
              (c!.unitsQuantity * c.unitsSumPower * getMoneyWeightFactor(_nationMoney)) / _correctionFactor,
          data: _SpecialStrikeEstimationData(
            cell: c.cell,
            type: SpecialStrikeType.gasAttack,
          ),
        ));
  }
}
