part of game_field_sm;

abstract class GameObjectTransitionBase {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldRead _gameField;

  GameObjectTransitionBase(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldRead gameField,
  ) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
  }

  @protected
  Iterable<GameFieldCell> _calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) =>
      PathFacade.calculatePath(gameField: _gameField, startCell: startCell, endCell: endCell);

  @protected
  Iterable<GameFieldCell> _estimatePath({required Iterable<GameFieldCell> path}) =>
      PathFacade.estimatePath(path: path);
}
