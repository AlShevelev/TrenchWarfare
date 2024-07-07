part of aggressive_player_ai;

class TerrainModifierEstimationProcessor extends EstimationProcessorBase<TerrainModifierEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  TerrainModifierEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<TerrainModifierEstimationData>> _makeEstimations() {
    final List<EstimationResult<TerrainModifierEstimationData>> result = [];

    result.addAll(
      AntiAirGunEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      BarbedWireEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      LandFortEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      MineFieldsEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
        type: TerrainModifierType.landMine,
      ).estimate(),
    );

    result.addAll(
      MineFieldsEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
        type: TerrainModifierType.seaMine,
      ).estimate(),
    );

    result.addAll(
      TrenchEstimator(
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
  GameFieldControlsCard _toCard(EstimationResult<TerrainModifierEstimationData> estimationItem) =>
      GameFieldControlsTerrainModifiersCardBrief(type: estimationItem.data.type);
}
