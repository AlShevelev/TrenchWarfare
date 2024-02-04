part of movement;

abstract class MovementCalculator {
  @protected
  late final GameFieldReadOnly _gameField;

  MovementCalculator({required GameFieldReadOnly gameField}) {
    _gameField = gameField;
  }

  State startMovement(Iterable<GameFieldCell> path);

  @protected
  bool _canMove({
    required GameFieldCell startCell,
    required bool isLandUnit,
  }) =>
      PathFacade(isLandUnit, _gameField).canMove(startCell);
}