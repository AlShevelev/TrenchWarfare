part of game_field_sm;

class FromPathIsShownOnEndOfTurnButtonClick extends GameObjectTransitionBase {
  FromPathIsShownOnEndOfTurnButtonClick(super.context);

  State process(Iterable<GameFieldCellRead> path) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

    final unit = pathToProcess.first.activeUnit!;

    // Click to the unit cell - reset the selection
    _hideArmyPanel();

    unit.setState(UnitState.enabled);

    _resetPath(pathToProcess);

    return TurnIsEnded();
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _context.updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
  }

  void _hideArmyPanel() => _context.controlsState.update(
        MainControls(
          totalSum: _context.money.totalSum,
          cellInfo: null,
          armyInfo: null,
          carrierInfo: null,
        ),
      );
}
