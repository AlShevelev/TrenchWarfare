part of money_spending_phase_library;

class _AttackDefenceCellWithFactors {
  final GameFieldCellRead cell;

  final int unitIndex;

  final bool hasArtillery;

  final bool hasMachineGun;

  _AttackDefenceCellWithFactors({
    required this.cell,
    required this.unitIndex,
    required this.hasArtillery,
    required this.hasMachineGun,
  });
}

/// Should we add an attack or defence booster in general?
class _AttackDefenceEstimator extends Estimator<_UnitBoosterEstimationData> {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  final UnitBoost _type;

  static const _weight = 2.0;

  _AttackDefenceEstimator({
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyUnit nationMoney,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
    required UnitBoost type,
  })  : _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _influenceMap = influenceMap,
        _metadata = metadata,
        _type = type;

  @override
  Iterable<EstimationResult<_UnitBoosterEstimationData>> estimate() {
    if (_type != UnitBoost.attack && _type != UnitBoost.defence) {
      throw UnsupportedError('This type of booster is not supported: $_type');
    }

    final buildCalculator = UnitBoosterBuildCalculator(_gameField, _myNation);
    final cellsPossibleToBuild = buildCalculator.getAllCellsPossibleToBuild(_type, _nationMoney);

    // We can't build shit
    if (cellsPossibleToBuild.isEmpty) {
      return [];
    }

    final allAggressors = _metadata.getMyEnemies(_myNation);

    final List<_AttackDefenceCellWithFactors> cellsPossibleToBuildExt = [];

    for (final cell in cellsPossibleToBuild) {
      final cellFromMap = _influenceMap.getItem(cell.row, cell.col);

      if (!allAggressors.any((a) => cellFromMap.hasAny(a))) {
        continue;
      }

      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);
        if (buildCalculator.canBuildForUnit(unit, _type)) {
          cellsPossibleToBuildExt.add(_AttackDefenceCellWithFactors(
            cell: cell,
            unitIndex: i,
            hasArtillery: unit.hasArtillery,
            hasMachineGun: unit.hasMachineGun,
          ));
        }
      }
    }

    if (cellsPossibleToBuildExt.isEmpty) {
      return [];
    }

    return cellsPossibleToBuildExt.map((c) => EstimationResult<_UnitBoosterEstimationData>(
          weight: _weight +
              (c.hasArtillery ? _weight : 0) +
              (c.hasMachineGun ? _weight : 0) +
              (_type == UnitBoost.defence && c.cell.productionCenter != null ? _weight : 0),
          data: _UnitBoosterEstimationData(
            cell: c.cell,
            type: _type,
            unitIndex: c.unitIndex,
          ),
        ));
  }
}
