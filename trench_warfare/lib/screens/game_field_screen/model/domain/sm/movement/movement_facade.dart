part of movement;

class MovementFacade {
  late final Nation _nation;
  late final GameFieldReadOnly _gameField;
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementFacade({
    required Nation nation,
    required GameFieldReadOnly gameField,
    required SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _nation = nation;
    _gameField = gameField;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  State startMovement(Iterable<GameFieldCell> path) {
    final calculator = path.map((e) => e.pathItem!).any((e) => e.isActive && e.type == PathItemType.explosion) ?
    MovementWithMineFieldCalculator(
      nation: _nation,
      gameField: _gameField,
      updateGameObjectsEvent: _updateGameObjectsEvent,
    ) :
    MovementWithoutObstaclesCalculator(
      nation: _nation,
      gameField: _gameField,
      updateGameObjectsEvent: _updateGameObjectsEvent,
    );

    return calculator.startMovement(path);
  }
}
