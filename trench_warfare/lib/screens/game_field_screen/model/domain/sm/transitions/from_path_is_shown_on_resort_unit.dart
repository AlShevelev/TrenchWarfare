part of game_field_sm;

class FromPathIsShownOnResortUnit extends GameObjectTransitionBase {
  FromPathIsShownOnResortUnit(super.context);

  State process(Iterable<GameFieldCell> path, int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    final cell = _context.gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit!;

    if (activeUnit.state == UnitState.active) {
      activeUnit.setState(UnitState.enabled);
    }

    if (isCarrier) {
      (activeUnit as Carrier).resortUnits(unitsId);
    } else {
      cell.resortUnits(unitsId);

      final newActiveUnit = cell.activeUnit!;

      CarrierPanelCalculator.updateCarrierPanel(
        cellId,
        _context.controlsState,
        oldActiveUnit: activeUnit,
        newActiveUnit: newActiveUnit,
      );
    }

    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }

    _context.updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));

    return ReadyForInput();
  }
}
