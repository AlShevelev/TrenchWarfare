part of money_spending_phase_library;

class _TerrainModifierEstimationProcessor extends _EstimationProcessorBase<_TerrainModifierEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  _TerrainModifierEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<_TerrainModifierEstimationData>> _makeEstimations() {
    final List<EstimationResult<_TerrainModifierEstimationData>> result = [];

    result.addAll(
      _AntiAirGunEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _BarbedWireEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _LandFortEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _MineFieldsEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
        type: TerrainModifierType.landMine,
      ).estimate(),
    );

    result.addAll(
      _MineFieldsEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
        type: TerrainModifierType.seaMine,
      ).estimate(),
    );

    result.addAll(
      _TrenchEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    return result;
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_TerrainModifierEstimationData> estimationItem) =>
      GameFieldControlsTerrainModifiersCardBrief(type: estimationItem.data.type);
}
