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

class FromPathIsShownOnMenuButtonClick extends FromReadyForInputOnMenuButtonClick {
  final Iterable<GameFieldCellRead> _path;

  FromPathIsShownOnMenuButtonClick(super.context, Iterable<GameFieldCellRead> path) : _path = path;

  @override
  State process() {
    // The unit's deactivation
    _path.first.activeUnit?.setState(UnitState.enabled);

    // Clearing the path
    for (final cell in _path) {
      (cell as GameFieldCell).setPathItem(null);
    }

    _context.updateGameObjectsEvent.update(
        _path.map((c) => UpdateCell(c as GameFieldCell, updateBorderCells: [])).toList(growable: false));

    return super.process();
  }
}
