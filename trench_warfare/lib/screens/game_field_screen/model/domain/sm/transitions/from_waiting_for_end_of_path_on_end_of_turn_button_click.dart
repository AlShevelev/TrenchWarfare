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

class FromWaitingForEndOfPathOnEndOfTurnButtonClick {
  final GameFieldStateMachineContext _context;

  FromWaitingForEndOfPathOnEndOfTurnButtonClick(this._context);

  State process(GameFieldCell startCell) {
    final unit = startCell.activeUnit!;

    _hideArmyPanel();
    unit.setState(UnitState.enabled);
    _context.updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);

    return TransitionUtils(_context).processEndOfTurn();
  }

  void _hideArmyPanel() => TransitionUtils(_context).closeUI();
}
