part of game_field_sm;

class FromWaitingForEndOfPathOnClick extends GameObjectTransitionBase {
  FromWaitingForEndOfPathOnClick(super.context);

  State process(GameFieldCell startCell, GameFieldCell endCell) {
    final unit = startCell.activeUnit!;

    if (startCell == endCell) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);
      _context.updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);
      return ReadyForInput();
    }

    // calculate a path
    Iterable<GameFieldCellRead> path = _calculatePath(startCell: startCell, endCell: endCell);

    if (path.isEmpty) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);

      if (!_context.isAI) {
        _context.updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);
      }
      return ReadyForInput();
    }

    final estimatedPath = _estimatePath(path: path);
    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));
    }

    return PathIsShown(estimatedPath);
  }

  void _hideArmyPanel() =>
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));
}
