part of game_field_sm;

class FromPathIsShownOnDisbandUnitButtonClick {
  final GameFieldStateMachineContext _context;

  final Iterable<GameFieldCellRead> _path;

  FromPathIsShownOnDisbandUnitButtonClick(this._context, this._path);

  State process() {
    _context.controlsState.update(DisbandUnitConfirmationControls());

    return DisbandUnitConfirmationNeeded(cellWithUnitToDisband: _path.first, pathOfUnit: _path);
  }
}