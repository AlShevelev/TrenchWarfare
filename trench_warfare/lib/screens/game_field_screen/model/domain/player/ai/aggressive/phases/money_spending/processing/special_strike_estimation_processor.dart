part of aggressive_player_ai;

class SpecialStrikeEstimationProcessor extends EstimationProcessorBase<SpecialStrikeEstimationData> {
  final _signal = AsyncSignal(locked: true);

  SpecialStrikeEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<SpecialStrikeEstimationData>> _makeEstimations() {
    final List<EstimationResult<SpecialStrikeEstimationData>> result = [];

    result.addAll(
      AirBombardmentEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        metadata: _metadata,
        influenceMap: _influenceMap,
      ).estimate(),
    );

    result.addAll(
      FlameTroopersEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      FlechettesEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      GasAttackEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      PropagandaEstimator(
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
  void _simulateCardSelection({required GameFieldControlsCard card, required GameFieldCellRead cell}) async {
    super._simulateCardSelection(card: card, cell: cell);
    await _signal.wait();
  }

  @override
  void onAnimationCompleted() {
    _signal.unlock();
    _signal.close();
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<SpecialStrikeEstimationData> estimationItem) =>
      GameFieldControlsSpecialStrikesCardBrief(type: estimationItem.data.type);
}
