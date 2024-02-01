part of game_field_sm;

abstract class TransitionBase {
  @protected
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldReadOnly _gameField;

  PathFacade? _pathFacade;

  TransitionBase(SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent, GameFieldReadOnly gameField) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
  }

  @protected
  Iterable<GameFieldCell> _calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
    required bool isLandUnit,
  }) => _getPathFacade(isLandUnit).calculatePath(startCell: startCell, endCell: endCell);

  @protected
  Iterable<GameFieldCell> _estimatePath({
    required Iterable<GameFieldCell> path,
    required bool isLandUnit,
  }) => _getPathFacade(isLandUnit).estimatePath(path: path);

  PathFacade _getPathFacade(bool isLandUnit) {
    final pathFacade = _pathFacade ?? PathFacade(isLandUnit, _gameField);
    _pathFacade = pathFacade;
    return pathFacade;
  }

  bool canMove({required GameFieldCell startCell, required bool isLandUnit,}) => _getPathFacade(isLandUnit).canMove(startCell);
}