part of game_field_sm;

abstract class GameObjectTransitionBase {
  @protected
  late final GameFieldStateMachineContext _context;

  @protected
  late final PathFacade _pathFacade;

  GameObjectTransitionBase(
    GameFieldStateMachineContext context,
  ) {
    _context = context;
    _pathFacade = PathFacade(context.gameField);
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
