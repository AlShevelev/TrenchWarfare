part of game_field_sm;

class FromPathIsShownOnResortUnit {
  final GameFieldStateMachineContext _context;

  FromPathIsShownOnResortUnit(this._context);

  State process(
    Iterable<GameFieldCellRead> path,
    int cellId,
    Iterable<String> unitsId, {
    required bool isInCarrierMode,
  }) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

    final cell = _context.gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;

    if (isInCarrierMode) {
      (activeUnit as Carrier).resortUnits(unitsId);

      return PathIsShown(path);
    } else {
      if (activeUnit != null && activeUnit.state == UnitState.active) {
        activeUnit.setState(UnitState.enabled);

        TransitionUtils(_context).closeUI();
      }

      cell.resortUnits(unitsId);
    }

    for (var pathCell in pathToProcess) {
      pathCell.setPathItem(null);
    }

    _context.updateGameObjectsEvent.update(pathToProcess.map((c) => UpdateCell(c, updateBorderCells: [])));

    return ReadyForInput();
  }
}
