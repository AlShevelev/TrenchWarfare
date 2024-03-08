part of movement;

class MovementFacade {
  late final Nation _nation;
  late final GameFieldRead _gameField;
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementFacade({
    required Nation nation,
    required GameFieldRead gameField,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _nation = nation;
    _gameField = gameField;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  State startMovement(Iterable<GameFieldCell> path) {
    final activePathItems = path.map((e) => e.pathItem!).where((e) => e.isActive).toList();

    final calculator = activePathItems.any((e) => e.type == PathItemType.explosion)
        ? MovementWithMineFieldCalculator(
            nation: _nation,
            gameField: _gameField,
            updateGameObjectsEvent: _updateGameObjectsEvent,
          )
        : activePathItems.any((e) => e.type == PathItemType.battle)
            ? MovementWithBattleCalculator(
                nation: _nation,
                gameField: _gameField,
                updateGameObjectsEvent: _updateGameObjectsEvent,
              )
            : MovementWithoutObstaclesCalculator(
                nation: _nation,
                gameField: _gameField,
                updateGameObjectsEvent: _updateGameObjectsEvent,
              );

    return calculator.startMovement(path);
  }
}
