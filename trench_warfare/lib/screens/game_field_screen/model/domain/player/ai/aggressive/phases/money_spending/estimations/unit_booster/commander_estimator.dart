part of money_spending_phase_library;

class _CommanderCellWithFactors {
  final GameFieldCellRead cell;

  final int unitIndex;

  final double unitPower;

  final UnitExperienceRank unitExperienceRank;

  /// [0 - 1]
  final double unitHealthRelative;

  _CommanderCellWithFactors({
    required this.cell,
    required this.unitIndex,
    required this.unitPower,
    required this.unitExperienceRank,
    required this.unitHealthRelative,
  });
}

/// Should we add a commander booster in general?
class _CommanderEstimator implements Estimator<_UnitBoosterEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  static const _type = UnitBoost.commander;

  _CommanderEstimator({
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
  Iterable<EstimationResult<_UnitBoosterEstimationData>> estimate() {
    final buildCalculator = UnitBoosterBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final List<_CommanderCellWithFactors> cellsPossibleToBuildExt = [];

    for (final cell in cellsPossibleToBuild) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
        continue;
      }

      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);
        if (buildCalculator.canBuildForUnit(unit, _type)) {
          cellsPossibleToBuildExt.add(_CommanderCellWithFactors(
            cell: cell,
            unitIndex: i,
            unitPower: UnitPowerEstimation.estimate(unit),
            unitExperienceRank: unit.experienceRank,
            unitHealthRelative: unit.health / unit.maxHealth,
          ));
        }
      }
    }

    if (cellsPossibleToBuildExt.isEmpty) {
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<_UnitBoosterEstimationData>(
          weight: 1.0 +
              c.unitPower +
              _experienceToWeight(c.unitExperienceRank) +
              2 * log10(1 / c.unitHealthRelative),
          data: _UnitBoosterEstimationData(
            cell: c.cell,
            type: _type,
            unitIndex: c.unitIndex,
          ),
        ));
  }

  double _experienceToWeight(UnitExperienceRank rank) => switch (rank) {
        UnitExperienceRank.rookies => 2,
        UnitExperienceRank.fighters => 1.5,
        UnitExperienceRank.proficients => 1,
        UnitExperienceRank.veterans => 0.5,
        UnitExperienceRank.elite => 0,
      };
}
