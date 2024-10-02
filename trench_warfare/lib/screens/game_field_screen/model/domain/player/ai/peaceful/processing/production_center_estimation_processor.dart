part of peaceful_player_ai;

class ProductionCenterEstimationProcessor extends EstimationProcessorBase<ProductionCenterEstimationData> {
  ProductionCenterEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<ProductionCenterEstimationData>> _makeEstimations() {
    final List<EstimationResult<ProductionCenterEstimationData>> result = [];

    final types = [ProductionCenterType.navalBase, ProductionCenterType.city, ProductionCenterType.factory];

    for (final type in types) {
      final estimator = ProductionCenterEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        type: type,
        influenceMap: _influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  Future<void> process() async {
    final allWeights = _estimationResult.map((e) => 1.0).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    await _simulateCardSelection(
      card: GameFieldControlsProductionCentersCardBrief(
        type: _estimationResult.elementAt(caseIndex).data.type,
      ),
      cell: _estimationResult.elementAt(caseIndex).data.cell,
    );
  }
}
