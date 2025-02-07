part of game_field_sm;

class FromPathIsShownOnDisbandUnitButtonClick {
  final GameFieldStateMachineContext _context;

  final Iterable<GameFieldCellRead> _path;

  FromPathIsShownOnDisbandUnitButtonClick(this._context, this._path);

  State process() {
    final cell = _path.first;
    _context.controlsState.update(DisbandUnitConfirmationControls(
      unitToShow: cell.activeUnit!,
      nation: cell.nation!,
    ));

    return DisbandUnitConfirmationNeeded(cellWithUnitToDisband: _path.first, pathOfUnit: _path);
  }
}
