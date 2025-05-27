/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

class FromWaitingForEndOfPathOnDisbandUnitButtonClick {
  final GameFieldStateMachineContext _context;

  final GameFieldCellRead _startPathCell;

  FromWaitingForEndOfPathOnDisbandUnitButtonClick(this._context, this._startPathCell);

  State process() {
    final uiState = _context.controlsState.current!;

    _context.controlsState.update(DisbandUnitConfirmationControls(
      unitToShow: _startPathCell.activeUnit!,
      nation: _startPathCell.nation!,
    ));

    return DisbandUnitConfirmationNeeded(
      cellWithUnitToDisband: _startPathCell,
      pathOfUnit: [],
      priorUiState: uiState,
    );
  }
}
