part of game_field_sm;

class FromPathIsShownOnResortUnit extends GameObjectTransitionBase {
  FromPathIsShownOnResortUnit(super.context);

  State process(Iterable<GameFieldCellRead> path, int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

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

    for (var pathCell in pathToProcess) {
      pathCell.setPathItem(null);
    }

    _context.updateGameObjectsEvent.update(pathToProcess.map((c) => UpdateCell(c, updateBorderCells: [])));

    return ReadyForInput();
  }
}
