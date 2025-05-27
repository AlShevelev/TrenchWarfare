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

class FromPathIsShownOnDisbandUnitButtonClick {
  final GameFieldStateMachineContext _context;

  final Iterable<GameFieldCellRead> _path;

  FromPathIsShownOnDisbandUnitButtonClick(this._context, this._path);

  State process() {
    final uiState = _context.controlsState.current!;

    final cell = _path.first;
    _context.controlsState.update(DisbandUnitConfirmationControls(
      unitToShow: cell.activeUnit!,
      nation: cell.nation!,
    ));

    return DisbandUnitConfirmationNeeded(
      cellWithUnitToDisband: _path.first,
      pathOfUnit: _path,
      priorUiState: uiState,
    );
  }
}
