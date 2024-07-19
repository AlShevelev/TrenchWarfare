part of aggressive_player_ai;

abstract class UnitEstimationProcessorBase {
  @protected
  final PlayerActions _actions;

  UnitEstimationProcessorBase({required PlayerActions actions}) : _actions = actions;

  /// Returns a weight of the estimation. Zero value means - the estimation is impossible
  double estimate();

  /// Returns a target cell for the action
  Future<GameFieldCellRead> processAction();
}