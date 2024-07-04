part of peaceful_player_ai;

class MineFieldEstimationProcessor extends EstimationProcessorBase<MineFieldsEstimationData> {
  MineFieldEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<MineFieldsEstimationData>> _makeEstimations() {
    final List<EstimationResult<MineFieldsEstimationData>> result = [];

    final types = [TerrainModifierType.landMine, TerrainModifierType.seaMine];

    for (final type in types) {
      final estimator = MineFieldsEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney.actual,
          influenceMap: _influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  void process() {
    final allWeights = _estimationResult.map((e) => e.data.dangerousFactor).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsTerrainModifiersCardBrief(
        type: _estimationResult.elementAt(caseIndex).data.type,
      ),
      cell: _estimationResult.elementAt(caseIndex).data.cell,
    );
  }
}
