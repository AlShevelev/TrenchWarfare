/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
  late final List<Nation> _allEnemies;

  @protected
  double get _balanceFactor => 1.0;

  @protected
  final PathFacade _pathFacade;

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
        _gameField = gameField,
        _pathFacade = PathFacade(gameField, myNation, metadata) {
    _allEnemies = _metadata.getEnemies(_myNation);
  }

  /// Returns a weight of the estimation. Zero value means - the estimation is impossible
  double estimate() => _balanceFactor * _estimateInternal();

  /// Returns a target cell for the action
  Future<List<UnitUpdateResultItem>?> processAction();

  @protected
  double _estimateInternal();

  @protected
  bool _isEnemyCell(GameFieldCellRead cell) => _allEnemies.contains(cell.nation);
}
