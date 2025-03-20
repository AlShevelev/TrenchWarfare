part of game_field_sm;

class TransitionUtils {
  final GameFieldStateMachineContext _context;

  late final PathFacade _pathFacade = PathFacade(
    _context.gameField,
    _context.myNation,
    _context.mapMetadata,
  );

  TransitionUtils(GameFieldStateMachineContext context) : _context = context;

  void closeUI() {
    _context.controlsState.update(MainControls(
      totalSum: _context.money.totalSum,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
      nation: _context.myNation,
      showDismissButton: false,
    ));
  }

  Iterable<GameFieldCellRead> calculatePath({
    required GameFieldCellRead startCell,
    required GameFieldCellRead endCell,
  }) =>
      _pathFacade.calculatePath(startCell: startCell, endCell: endCell);

  Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCellRead> path}) =>
      _pathFacade.estimatePath(path: path);

  void setCameraPosition(List<UpdateGameEvent> events) {
    final cameraPosition = _context.isAI ? null : _context.gameFieldSettingsStorage.cameraPosition;
    final zoomLevel = _context.gameFieldSettingsStorage.zoom ?? ZoomConstants.startZoom;

    events.add(SetCamera(
      zoomLevel,
      cameraPosition,
    ));

    if (cameraPosition == null) {
      final cellToMove = _context.gameField.cells
          .firstWhereOrNull((c) => c.nation == _context.myNation && c.isLand && c.productionCenter != null);
      if (cellToMove != null) {
        events.add(MoveCameraToCell(cellToMove));
      }
    }
  }

  State processEndOfTurn() {
    if (_context.isAI) {
      return TurnIsEnded();
    }

    final activeUnitCell = _context.gameField.cells.firstWhereOrNull((c) =>
        c.nation == _context.myNation &&
        c.units.isNotEmpty &&
        c.units.any((u) => u.state == UnitState.active || u.state == UnitState.enabled));

    if (activeUnitCell == null) {
      return TurnIsEnded();
    } else {
      _context.controlsState.update(EndOfTurnConfirmationControls());
      return TurnEndConfirmationNeeded(activeUnitCell);
    }
  }
}
