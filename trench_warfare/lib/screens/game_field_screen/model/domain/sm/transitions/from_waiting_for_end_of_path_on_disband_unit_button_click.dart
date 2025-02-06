part of game_field_sm;

class FromWaitingForEndOfPathOnDisbandUnitButtonClick {
  final GameFieldStateMachineContext _context;

  final GameFieldCellRead _startPathCell;

  FromWaitingForEndOfPathOnDisbandUnitButtonClick(this._context, this._startPathCell);

  State process() {
    _context.controlsState.update(DisbandUnitConfirmationControls());

    return DisbandUnitConfirmationNeeded(cellWithUnitToDisband: _startPathCell, pathOfUnit: []);
  }
}