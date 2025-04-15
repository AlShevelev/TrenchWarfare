part of money_spending_phase_library;

abstract interface class _EstimationProcessor {
  /// Makes estimation
  /// [result] average weight of the estimated factors
  double estimate();

  /// Process estimation result
  Future<List<UnitUpdateResultItem>?> process();

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

  final UnitUpdateResultBridgeRead? _unitUpdateResultBridge;

  final _signal = AsyncSignal(locked: true);

  _EstimationProcessorBase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required MapMetadataRead metadata,
    required InfluenceMapRepresentationRead influenceMap,
    required UnitUpdateResultBridgeRead? unitUpdateResultBridge,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _influenceMap = influenceMap,
        _unitUpdateResultBridge = unitUpdateResultBridge;

  /// Makes estimation
  /// [result] average weight of the estimated factors
  @override
  double estimate() {
    _estimationResult = _makeEstimations();
    return _calculateAverageWeight(_estimationResult);
  }

  /// Process estimation result
  @override
  Future<List<UnitUpdateResultItem>?> process() async {
    final allWeights = _estimationResult.map((e) => e.weight).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return null;
    }

    // User action simulation
    return await _simulateCardSelection(
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
          .let((v) => v == 0 ? 0.0 : _averageWeightBalanceFactor * InGameMath.log10(v))!;

  @protected
  Future<List<UnitUpdateResultItem>?> _simulateCardSelection({
    required GameFieldControlsCard card,
    required GameFieldCellRead cell,
  }) async {
    _player.onCardsButtonClick();
    _player.onCardSelected(card);
    _player.onClick(cell.center);
    await _signal.wait();

    return _unitUpdateResultBridge?.extractResult();
  }

  @protected
  GameFieldControlsCard _toCard(EstimationResult<D> estimationItem);

  @override
  void onAnimationCompleted() {
    _player.onCardsPlacingCancelled();

    _signal.unlock();
    _signal.close();
  }
}
