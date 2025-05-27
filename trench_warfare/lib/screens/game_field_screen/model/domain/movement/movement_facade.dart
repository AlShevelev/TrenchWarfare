/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of movement;

class MovementFacade {
  final Nation _myNation;

  final Nation _humanNation;

  final GameFieldRead _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  final AnimationTime _animationTime;

  final UnitUpdateResultBridge? _unitUpdateResultBridge;

  final PathFacade _pathFacade;

  MovementFacade({
    required Nation myNation,
    required Nation humanNation,
    required GameFieldRead gameField,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required AnimationTime animationTime,
    required UnitUpdateResultBridge? unitUpdateResultBridge,
    required MapMetadataRead metadata,
  })  : _myNation = myNation,
        _humanNation = humanNation,
        _gameField = gameField,
        _updateGameObjectsEvent = updateGameObjectsEvent,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _animationTime = animationTime,
        _unitUpdateResultBridge = unitUpdateResultBridge,
        _pathFacade = PathFacade(gameField, myNation, metadata);

  State startMovement(Iterable<GameFieldCell> path) {
    final activePathItems = path.map((e) => e.pathItem!).where((e) => e.isActive).toList();

    late MovementCalculator calculator;

    if (_myNation != _humanNation && path.first.activeUnit?.isInDefenceMode == true) {
      // The only action for AI-played unit in defence mode is attacking an enemy on the next cell without
      // movement to the cell - so, we should use MovementWithBattleNextUnreachableCell
      calculator = MovementWithBattleNextUnreachableCell(
        myNation: _myNation,
        humanNation: _humanNation,
        gameField: _gameField,
        updateGameObjectsEvent: _updateGameObjectsEvent,
        gameOverConditionsCalculator: _gameOverConditionsCalculator,
        animationTime: _animationTime,
        unitUpdateResultBridge: _unitUpdateResultBridge,
        pathFacade: _pathFacade,
      );
    } else {
      calculator = activePathItems.any((e) => e.type == PathItemType.explosion)
          ? MovementWithMineFieldCalculator(
              myNation: _myNation,
              humanNation: _humanNation,
              gameField: _gameField,
              updateGameObjectsEvent: _updateGameObjectsEvent,
              gameOverConditionsCalculator: _gameOverConditionsCalculator,
              animationTime: _animationTime,
              unitUpdateResultBridge: _unitUpdateResultBridge,
              pathFacade: _pathFacade,
            )
          : activePathItems.any((e) => e.type == PathItemType.battle)
              ? MovementWithBattleCalculator(
                  myNation: _myNation,
                  humanNation: _humanNation,
                  gameField: _gameField,
                  updateGameObjectsEvent: _updateGameObjectsEvent,
                  gameOverConditionsCalculator: _gameOverConditionsCalculator,
                  animationTime: _animationTime,
                  unitUpdateResultBridge: _unitUpdateResultBridge,
                  pathFacade: _pathFacade,
                )
              : activePathItems.any((e) => e.type == PathItemType.battleNextUnreachableCell)
                  ? MovementWithBattleNextUnreachableCell(
                      myNation: _myNation,
                      humanNation: _humanNation,
                      gameField: _gameField,
                      updateGameObjectsEvent: _updateGameObjectsEvent,
                      gameOverConditionsCalculator: _gameOverConditionsCalculator,
                      animationTime: _animationTime,
                      unitUpdateResultBridge: _unitUpdateResultBridge,
                      pathFacade: _pathFacade,
                    )
                  : MovementWithoutObstaclesCalculator(
                      myNation: _myNation,
                      humanNation: _humanNation,
                      gameField: _gameField,
                      updateGameObjectsEvent: _updateGameObjectsEvent,
                      gameOverConditionsCalculator: _gameOverConditionsCalculator,
                      animationTime: _animationTime,
                      unitUpdateResultBridge: _unitUpdateResultBridge,
                      pathFacade: _pathFacade,
                    );
    }

    return calculator.startMovement(path);
  }
}
