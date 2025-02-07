part of game_field_sm;

class FromDisbandUnitConfirmationNeededOnUserDeclined {
  final GameFieldStateMachineContext _context;

  final GameFieldCellRead _cellWithUnitToDisband;

  final Iterable<GameFieldCellRead> _pathOfUnit;

  FromDisbandUnitConfirmationNeededOnUserDeclined(
      {required GameFieldStateMachineContext context,
      required GameFieldCellRead cellWithUnitToDisband,
      required Iterable<GameFieldCellRead> pathOfUnit})
      : _context = context,
        _cellWithUnitToDisband = cellWithUnitToDisband,
        _pathOfUnit = pathOfUnit;

  State process() {
    // Hid the dialog
    final state = (_context.controlsState.current as MainControls);
    _context.controlsState.update(state.setShowDismissButton(false));

    if (_pathOfUnit.isEmpty) {
      return WaitingForEndOfPath(_cellWithUnitToDisband as GameFieldCell);
    } else {
      return PathIsShown(_pathOfUnit);
    }
  }
}
