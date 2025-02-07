part of game_field_sm;

class FromDisbandUnitConfirmationNeededOnUserDeclined {
  final GameFieldStateMachineContext _context;

  final GameFieldCellRead _cellWithUnitToDisband;

  final Iterable<GameFieldCellRead> _pathOfUnit;

  final GameFieldControlsState _priorUiState;

  FromDisbandUnitConfirmationNeededOnUserDeclined({
    required GameFieldStateMachineContext context,
    required GameFieldCellRead cellWithUnitToDisband,
    required Iterable<GameFieldCellRead> pathOfUnit,
    required GameFieldControlsState priorUiState,
  })  : _context = context,
        _cellWithUnitToDisband = cellWithUnitToDisband,
        _pathOfUnit = pathOfUnit,
        _priorUiState = priorUiState;

  State process() {
    // Hid the dialog
    _context.controlsState.update(_priorUiState);

    if (_pathOfUnit.isEmpty) {
      return WaitingForEndOfPath(_cellWithUnitToDisband as GameFieldCell);
    } else {
      return PathIsShown(_pathOfUnit);
    }
  }
}
