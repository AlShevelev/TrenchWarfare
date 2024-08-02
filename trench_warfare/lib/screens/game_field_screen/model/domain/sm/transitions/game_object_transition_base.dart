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
  Iterable<GameFieldCellRead> _calculatePath({
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
  }) =>
      _pathFacade.calculatePath(startCell: startCell, endCell: endCell);

  @protected
  Iterable<GameFieldCell> _estimatePath({required Iterable<GameFieldCellRead> path}) =>
      _pathFacade.estimatePath(path: path);

  @protected
  void _setCameraPosition(List<UpdateGameEvent> events) {
    final cameraPosition = _context.isAI ? null : _context.gameFieldSettingsStorage.cameraPosition;
    final zoomLevel = _context.gameFieldSettingsStorage.zoom ?? ZoomConstants.startZoom;

    events.add(SetCamera(
      zoomLevel,
      cameraPosition,
    ));

    if (cameraPosition == null) {
      final cellToMove = _context.gameField.cells.firstWhereOrNull((c) => c.nation == _context.nation);
      if (cellToMove != null) {
        events.add(MoveCameraToCell(cellToMove));
      }
    }
  }
}
