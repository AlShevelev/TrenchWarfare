part of game_field_sm;

class FromWaitingForEndOfPathOnResortUnit extends GameObjectTransitionBase {
  FromWaitingForEndOfPathOnResortUnit(super.context);

  State process(
    GameFieldCell startPathCell,
    int cellId,
    Iterable<String> unitsId, {
    required bool isCarrier,
  }) {
    final cell = _context.gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;

    if (isCarrier) {
      (activeUnit! as Carrier).resortUnits(unitsId);

      return WaitingForEndOfPath(startPathCell);
    } else {
      if (activeUnit != null && activeUnit.state == UnitState.active) {
        activeUnit.setState(UnitState.enabled);
      }

      cell.resortUnits(unitsId);

      final newActiveUnit = cell.activeUnit!;

      CarrierPanelCalculator.updateCarrierPanel(
        cellId,
        cell.nation!,
        _context.controlsState,
        oldActiveUnit: activeUnit!,
        newActiveUnit: newActiveUnit,
      );

      _context.updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);

      return ReadyForInput();
    }
  }
}
