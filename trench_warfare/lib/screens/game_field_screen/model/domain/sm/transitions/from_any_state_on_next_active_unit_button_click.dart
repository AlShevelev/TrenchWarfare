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

class FromAnyStateOnNextActiveUnitButtonClick {
  final GameFieldStateMachineContext _context;

  FromAnyStateOnNextActiveUnitButtonClick(this._context);

  State process(State currentState) {
    final events = <UpdateGameEvent>[];

    int lastIndex = _context.nextActiveUnitLastSearchCellIndex;

    for (int i = lastIndex + 1; i < _context.gameField.cells.length; i++) {
      if (_checkCell(i, events)) break;
    }


    if (events.isEmpty) {
      for (int i = 0; i < lastIndex; i++) {
        if (_checkCell(i, events)) break;
      }
    }

    if (events.isNotEmpty) {
      _context.updateGameObjectsEvent.update(events);
    }

    return currentState;
  }

  bool _checkCell(int index, List<UpdateGameEvent> events) {
    final cell = _context.gameField.cells.elementAt(index);

    if (cell.nation == _context.myNation &&
        cell.units.isNotEmpty &&
        cell.units.first.state != UnitState.disabled) {

      events.add(MoveCameraToCell(cell));
      _context.nextActiveUnitLastSearchCellIndex = index;

      return true;
    }

    return false;
  }
}
