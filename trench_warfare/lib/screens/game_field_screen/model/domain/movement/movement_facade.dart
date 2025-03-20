part of movement;

class MovementFacade {
  final Nation _myNation;

  final GameFieldRead _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final AnimationTime _animationTime;

  final MovementResultBridge? _movementResultBridge;

  final PathFacade _pathFacade;

  MovementFacade({
    required Nation myNation,
    required GameFieldRead gameField,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required AnimationTime animationTime,
    required MovementResultBridge? movementResultBridge,
    required MapMetadataRead metadata,
  })  : _myNation = myNation,
        _gameField = gameField,
        _updateGameObjectsEvent = updateGameObjectsEvent,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _animationTime = animationTime,
        _movementResultBridge = movementResultBridge,
        _pathFacade = PathFacade(gameField, myNation, metadata);

  State startMovement(Iterable<GameFieldCell> path) {
    final activePathItems = path.map((e) => e.pathItem!).where((e) => e.isActive).toList();

    final calculator = activePathItems.any((e) => e.type == PathItemType.explosion)
        ? MovementWithMineFieldCalculator(
            myNation: _myNation,
            gameField: _gameField,
            updateGameObjectsEvent: _updateGameObjectsEvent,
            gameOverConditionsCalculator: _gameOverConditionsCalculator,
            animationTime: _animationTime,
            movementResultBridge: _movementResultBridge,
            pathFacade: _pathFacade,
          )
        : activePathItems.any((e) => e.type == PathItemType.battle)
            ? MovementWithBattleCalculator(
                myNation: _myNation,
                gameField: _gameField,
                updateGameObjectsEvent: _updateGameObjectsEvent,
                gameOverConditionsCalculator: _gameOverConditionsCalculator,
                animationTime: _animationTime,
                movementResultBridge: _movementResultBridge,
                pathFacade: _pathFacade,
              )
            : activePathItems.any((e) => e.type == PathItemType.battleNextUnreachableCell)
                ? MovementWithBattleNextUnreachableCell(
                    myNation: _myNation,
                    gameField: _gameField,
                    updateGameObjectsEvent: _updateGameObjectsEvent,
                    gameOverConditionsCalculator: _gameOverConditionsCalculator,
                    animationTime: _animationTime,
                    movementResultBridge: _movementResultBridge,
                    pathFacade: _pathFacade,
                  )
                : MovementWithoutObstaclesCalculator(
                    myNation: _myNation,
                    gameField: _gameField,
                    updateGameObjectsEvent: _updateGameObjectsEvent,
                    gameOverConditionsCalculator: _gameOverConditionsCalculator,
                    animationTime: _animationTime,
                    movementResultBridge: _movementResultBridge,
                    pathFacade: _pathFacade,
                  );

    return calculator.startMovement(path);
  }
}
