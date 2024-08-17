part of units_moving_phase_library;

abstract class _UnitEstimationProcessorBase {
  @protected
  final PlayerActions _actions;

  @protected
  final InfluenceMapRepresentationRead _influences;

  @protected
  final Unit _unit;

  @protected
  final GameFieldCellRead _cell;

  @protected
  final Nation _myNation;

  @protected
  final MapMetadataRead _metadata;

  @protected
  final GameFieldRead _gameField;

  @protected
  late final _allOpponents = _metadata.getMyEnemies(_myNation);

  @protected
  double get _balanceFactor => 1.0;

  _UnitEstimationProcessorBase({
    required PlayerActions actions,
    required InfluenceMapRepresentationRead influences,
    required Unit unit,
    required GameFieldCellRead cell,
    required Nation myNation,
    required MapMetadataRead metadata,
    required GameFieldRead gameField,
  })  : _actions = actions,
        _influences = influences,
        _unit = unit,
        _cell = cell,
        _myNation = myNation,
        _metadata = metadata,
        _gameField = gameField;

  /// Returns a weight of the estimation. Zero value means - the estimation is impossible
  double estimate() => _balanceFactor * _estimateInternal();

  /// Returns a target cell for the action
  Future<void> processAction();

  @protected
  double _estimateInternal();

  @protected
  bool _isEnemyCell(GameFieldCellRead cell) => _allOpponents.contains(cell.nation);
}
