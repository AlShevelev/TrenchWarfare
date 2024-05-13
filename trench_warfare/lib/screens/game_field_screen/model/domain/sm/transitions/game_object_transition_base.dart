part of game_field_sm;

abstract class GameObjectTransitionBase {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldRead _gameField;

  @protected
  late final PathFacade _pathFacade;

  GameObjectTransitionBase(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldRead gameField,
  ) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
    _pathFacade = PathFacade(_gameField);
  }

  @protected
  Iterable<GameFieldCell> _calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) =>
      _pathFacade.calculatePath(startCell: startCell, endCell: endCell);

  @protected
  Iterable<GameFieldCell> _estimatePath({required Iterable<GameFieldCell> path}) =>
      _pathFacade.estimatePath(path: path);
}
