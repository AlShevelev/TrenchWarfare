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

class FromPathIsShownOnEndOfTurnButtonClick {
  final GameFieldStateMachineContext _context;

  FromPathIsShownOnEndOfTurnButtonClick(this._context);

  State process(Iterable<GameFieldCellRead> path) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

    final unit = pathToProcess.first.activeUnit!;

    // Click to the unit cell - reset the selection
    _hideArmyPanel();

    unit.setState(UnitState.enabled);

    _resetPath(pathToProcess);

    return TransitionUtils(_context).processEndOfTurn();
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _context.updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
  }

  void _hideArmyPanel() => TransitionUtils(_context).closeUI();
}
