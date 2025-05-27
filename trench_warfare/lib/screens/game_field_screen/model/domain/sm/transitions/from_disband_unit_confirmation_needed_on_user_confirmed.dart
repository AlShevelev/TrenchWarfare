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

class FromDisbandUnitConfirmationNeededOnUserConfirmed {
  final GameFieldStateMachineContext _context;

  final GameFieldCellRead _cellWithUnitToDisband;

  final Iterable<GameFieldCellRead> _pathOfUnit;

  FromDisbandUnitConfirmationNeededOnUserConfirmed({
    required GameFieldStateMachineContext context,
    required GameFieldCellRead cellWithUnitToDisband,
    required Iterable<GameFieldCellRead> pathOfUnit,
  })  : _context = context,
        _cellWithUnitToDisband = cellWithUnitToDisband,
        _pathOfUnit = pathOfUnit;

  State process() {
    // Hid the dialog
    TransitionUtils(_context).closeUI();

    // Disbanded the unit
    (_cellWithUnitToDisband as GameFieldCell).removeActiveUnit();

    // Cleared the path
    for (final cellPath in _pathOfUnit) {
      (cellPath as GameFieldCell).setPathItem(null);
    }

    final updateGameFieldEvents = _pathOfUnit.isEmpty
        ? [UpdateCell(_cellWithUnitToDisband, updateBorderCells: [])]
        : _pathOfUnit.map((c) => UpdateCell(c, updateBorderCells: [])).toList(growable: false);

    _context.updateGameObjectsEvent.update(updateGameFieldEvents);

    return ReadyForInput();
  }
}
