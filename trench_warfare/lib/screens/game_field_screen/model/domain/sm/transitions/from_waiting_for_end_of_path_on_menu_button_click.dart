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

class FromWaitingForEndOfPathOnMenuButtonClick extends FromReadyForInputOnMenuButtonClick {
  final GameFieldCellRead _startPathCell;

  FromWaitingForEndOfPathOnMenuButtonClick(super.context, GameFieldCellRead startPathCell)
      : _startPathCell = startPathCell;

  @override
  State process() {
    // The unit's deactivation
    _startPathCell.activeUnit?.setState(UnitState.enabled);

    _context.updateGameObjectsEvent.update([
      UpdateCell(_startPathCell as GameFieldCell, updateBorderCells: [])
    ]);

    return super.process();
  }
}
