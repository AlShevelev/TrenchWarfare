part of game_field_sm;

abstract class TransitionBase {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldRead _gameField;

  TransitionBase(SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent, GameFieldRead gameField) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
  }

  @protected
  Iterable<GameFieldCell> _calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
    required bool isLandUnit,
  }) => PathFacade.calculatePath(gameField: _gameField, startCell: startCell, endCell: endCell);

  @protected
  Iterable<GameFieldCell> _estimatePath({
    required Iterable<GameFieldCell> path,
    required bool isLandUnit,
  }) => PathFacade.estimatePath(path: path);
}