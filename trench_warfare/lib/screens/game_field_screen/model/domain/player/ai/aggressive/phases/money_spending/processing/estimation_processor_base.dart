part of money_spending_phase_library;

abstract interface class _EstimationProcessor {
  /// Makes estimation
  /// [result] average weight of the estimated factors
  double estimate();

  /// Process estimation result
  Future<void> process();

  /// Called when animation is completed
  void onAnimationCompleted();
}

abstract class _EstimationProcessorBase<D extends EstimationData> implements _EstimationProcessor {
  final PlayerInput _player;

  @protected
  final GameFieldRead _gameField;

  @protected
  final Nation _myNation;

  @protected
  final MoneyStorageRead _nationMoney;

  @protected
  final MapMetadataRead _metadata;

  @protected
  final InfluenceMapRepresentationRead _influenceMap;

  @protected
  late final Iterable<EstimationResult<D>> _estimationResult;

  /// Allows you to increase the probability of a particular processor triggering
  double get _averageWeightBalanceFactor;

  _EstimationProcessorBase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required MapMetadataRead metadata,
    required InfluenceMapRepresentationRead influenceMap,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _influenceMap = influenceMap;

  /// Makes estimation
  /// [result] average weight of the estimated factors
  @override
  double estimate() {
    _estimationResult = _makeEstimations();
    return _calculateAverageWeight(_estimationResult);
  }

  /// Process estimation result
  @override
  Future<void> process() async {
    final allWeights = _estimationResult.map((e) => e.weight).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    await _simulateCardSelection(
      card: _toCard(_estimationResult.elementAt(caseIndex)),
      cell: _estimationResult.elementAt(caseIndex).data.cell,
    );
  }

  @protected
  Iterable<EstimationResult<D>> _makeEstimations();

  double _calculateAverageWeight(Iterable<EstimationResult<D>> estimationResult) => estimationResult.isEmpty
      ? 0.0
      : estimationResult
          .map((e) => e.weight)
          .average()
          .let((v) => v == 0 ? 0.0 : _averageWeightBalanceFactor * log10(v))!;

  @protected
  Future<void> _simulateCardSelection({
    required GameFieldControlsCard card,
    required GameFieldCellRead cell,
  }) async {
    _player.onCardsButtonClick();
    _player.onCardSelected(card);
    _player.onClick(cell.center);
    _player.onCardsPlacingCancelled();
  }

  @protected
  GameFieldControlsCard _toCard(EstimationResult<D> estimationItem);

  @override
  void onAnimationCompleted() {
    // do noting
  }
}
