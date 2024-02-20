part of movement;

abstract class MovementCalculator {
  @protected
  late final GameFieldReadOnly _gameField;

  @protected
  late final Nation _nation;

  @protected
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementCalculator({
    required GameFieldReadOnly gameField,
    required Nation nation,
    required SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
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
