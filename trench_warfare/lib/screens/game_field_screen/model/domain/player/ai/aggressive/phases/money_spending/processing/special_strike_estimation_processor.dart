part of money_spending_phase_library;

class _SpecialStrikeEstimationProcessor extends _EstimationProcessorBase<_SpecialStrikeEstimationData> {
  @override
  double get _averageWeightBalanceFactor => 1.0;

  final _signal = AsyncSignal(locked: true);

  _SpecialStrikeEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<_SpecialStrikeEstimationData>> _makeEstimations() {
    final List<EstimationResult<_SpecialStrikeEstimationData>> result = [];

    result.addAll(
      _AirBombardmentEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        metadata: _metadata,
        influenceMap: _influenceMap,
      ).estimate(),
    );

    result.addAll(
      _FlameTroopersEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _FlechettesEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _GasAttackEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        influenceMap: _influenceMap,
        metadata: _metadata,
      ).estimate(),
    );

    result.addAll(
      _PropagandaEstimator(
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
  Future<void> _simulateCardSelection({
    required GameFieldControlsCard card,
    required GameFieldCellRead cell,
  }) async {
    _player.onCardsButtonClick();
    _player.onCardSelected(card);
    _player.onClick(cell.center);
    await _signal.wait();
  }

  @override
  void onAnimationCompleted() {
    _signal.unlock();
    _signal.close();
    _player.onCardsPlacingCancelled();
  }

  @override
  GameFieldControlsCard _toCard(EstimationResult<_SpecialStrikeEstimationData> estimationItem) =>
      GameFieldControlsSpecialStrikesCardBrief(type: estimationItem.data.type);
}
