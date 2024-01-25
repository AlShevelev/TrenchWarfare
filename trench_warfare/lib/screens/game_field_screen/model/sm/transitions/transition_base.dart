part of game_field_sm;

abstract class TransitionBase {
  @protected
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldReadOnly _gameField;

  TransitionBase(SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent, GameFieldReadOnly gameField) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
  }

  @protected
  Iterable<GameFieldCell> _calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
    required bool isLandUnit,
  }) {
    final settings = isLandUnit ? LandFindPathSettings(startCell: startCell) : SeaFindPathSettings(startCell: startCell);

    final pathFinder = FindPath(_gameField, settings);
    return pathFinder.find(startCell, endCell);
  }

  @protected
  Iterable<GameFieldCell> _estimatePath({
    required Iterable<GameFieldCell> path,
    required bool isLandUnit,
  }) =>
      (isLandUnit ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).calculate();
}