part of game_field_sm;

class FromWaitingForEndOfPathOnResortUnit {
  final GameFieldStateMachineContext _context;

  FromWaitingForEndOfPathOnResortUnit(this._context);

  State process(
    GameFieldCell startPathCell,
    int cellId,
    Iterable<String> unitsId, {
    required bool isInCarrierMode,
  }) {
    final cell = _context.gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;

    if (isInCarrierMode) {
      (activeUnit! as Carrier).resortUnits(unitsId);

      return WaitingForEndOfPath(startPathCell);
    } else {
      if (activeUnit != null && activeUnit.state == UnitState.active) {
        activeUnit.setState(UnitState.enabled);

        TransitionUtils(_context).closeUI();
      }

      cell.resortUnits(unitsId);

      _context.updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);

      return ReadyForInput();
    }
  }
}
