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

class FromVictoryDefeatConfirmationOnPopupDialogClosed {
  final GameFieldStateMachineContext _context;

  FromVictoryDefeatConfirmationOnPopupDialogClosed(this._context);

  State process(bool isVictory, Iterable<GameFieldCellRead> cellsToUpdate) {
    TransitionUtils(_context).closeUI();

    if (isVictory) {
      return GameIsOver();
    }

    _context.money.recalculateIncomeAndExpenses();

    // Clear all the cell of the defeated nation
    final events = cellsToUpdate
        .map((c) => UpdateCell(c as GameFieldCell, updateBorderCells: []))
        .toList(growable: false);
    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
