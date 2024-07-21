part of game_field_sm;

class FromPathIsShownOnClick extends GameObjectTransitionBase {
  FromPathIsShownOnClick(super.context);

  State process(Iterable<GameFieldCellRead> path, GameFieldCell cell) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

    final firstCell = pathToProcess.first;

    final unit = firstCell.activeUnit!;

    // Click to the unit cell - reset the selection
    if (cell == pathToProcess.first) {
      _hideArmyPanel();
      return _resetPathAndEnableUnit(pathToProcess, unit);
    }

    // Click to the last cell of the path - move the unit
    if (cell == pathToProcess.last) {
      _hideArmyPanel();

      return MovementFacade(
        nation: _context.nation,
        gameField: _context.gameField,
        updateGameObjectsEvent: _context.updateGameObjectsEvent,
      ).startMovement(pathToProcess);
    }

    // calculate a path
    Iterable<GameFieldCellRead> newPath = _calculatePath(startCell: firstCell, endCell: cell);

    if (newPath.isEmpty) {
      return _resetPathAndEnableUnit(pathToProcess, unit);
    }

    _resetPath(pathToProcess);

    // show the new path
    final estimatedPath = _estimatePath(path: newPath);
    _context.updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));

    return PathIsShown(newPath);
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _context.updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
  }

  /// Clear the path and make the unit enabled
  State _resetPathAndEnableUnit(Iterable<GameFieldCell> path, Unit unit) {
    unit.setState(UnitState.enabled);
    _resetPath(path);
    return ReadyForInput();
  }

  void _hideArmyPanel() =>
      _context.controlsState.update(MainControls(
        money: _context.money.actual,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ));
}
