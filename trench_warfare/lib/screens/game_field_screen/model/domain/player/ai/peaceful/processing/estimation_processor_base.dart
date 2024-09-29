part of peaceful_player_ai;

abstract interface class EstimationProcessor {
  /// Makes estimation
  /// [result] average weight of the estimated factors
  double estimate();

  /// Process estimation result
  Future<void> process();

  /// Called when animation is completed
  void onAnimationCompleted();
}

abstract class EstimationProcessorBase<D extends EstimationData> implements EstimationProcessor {
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

  final _signal = AsyncSignal(locked: true);

  EstimationProcessorBase({
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
  Future<void> process();

  @protected
  Iterable<EstimationResult<D>> _makeEstimations();

  double _calculateAverageWeight(Iterable<EstimationResult<D>> estimationResult) => estimationResult.isEmpty
      ? 0.0
      : estimationResult.map((e) => e.weight).average().let((v) => v <= 0 ? 0.0 : log10(v))!;

  @protected
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
}
