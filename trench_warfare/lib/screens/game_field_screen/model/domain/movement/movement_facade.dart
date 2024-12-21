part of movement;

class MovementFacade {
  final Nation _nation;

  final GameFieldRead _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final AnimationTime _animationTime;

  MovementFacade({
    required Nation nation,
    required GameFieldRead gameField,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required AnimationTime animationTime,
  })  : _nation = nation,
        _gameField = gameField,
        _updateGameObjectsEvent = updateGameObjectsEvent,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _animationTime = animationTime;

  State startMovement(Iterable<GameFieldCell> path) {
    final activePathItems = path.map((e) => e.pathItem!).where((e) => e.isActive).toList();

    final calculator = activePathItems.any((e) => e.type == PathItemType.explosion)
        ? MovementWithMineFieldCalculator(
            nation: _nation,
            gameField: _gameField,
            updateGameObjectsEvent: _updateGameObjectsEvent,
            gameOverConditionsCalculator: _gameOverConditionsCalculator,
            animationTime: _animationTime,
          )
        : activePathItems.any((e) => e.type == PathItemType.battle)
            ? MovementWithBattleCalculator(
                nation: _nation,
                gameField: _gameField,
                updateGameObjectsEvent: _updateGameObjectsEvent,
                gameOverConditionsCalculator: _gameOverConditionsCalculator,
                animationTime: _animationTime,
              )
            : activePathItems.any((e) => e.type == PathItemType.battleNextUnreachableCell)
                ? MovementWithBattleNextUnreachableCell(
                    nation: _nation,
                    gameField: _gameField,
                    updateGameObjectsEvent: _updateGameObjectsEvent,
                    gameOverConditionsCalculator: _gameOverConditionsCalculator,
                    animationTime: _animationTime,
                  )
                : MovementWithoutObstaclesCalculator(
                    nation: _nation,
                    gameField: _gameField,
                    updateGameObjectsEvent: _updateGameObjectsEvent,
                    gameOverConditionsCalculator: _gameOverConditionsCalculator,
                    animationTime: _animationTime,
                  );

    return calculator.startMovement(path);
  }
}
