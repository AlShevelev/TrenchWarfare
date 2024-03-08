part of movement;

abstract class MovementCalculator {
  @protected
  late final GameFieldRead _gameField;

  @protected
  late final Nation _nation;

  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementCalculator({
    required GameFieldRead gameField,
    required Nation nation,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _gameField = gameField;
    _nation = nation;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  State startMovement(Iterable<GameFieldCell> path);

  @protected
  bool _canMove({
    required GameFieldCell startCell,
    required bool isLandUnit,
  }) =>
      PathFacade.canMove(_gameField, startCell);
}
