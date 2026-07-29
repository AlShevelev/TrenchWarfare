part of game_field_sm;

class FromAnyStateOnNextActiveUnitButtonClick {
  final GameFieldStateMachineContext _context;

  FromAnyStateOnNextActiveUnitButtonClick(this._context);

  State process(State currentState) {
    final events = <UpdateGameEvent>[];

    int lastRow = _context.nextActiveUnitLastSearchCell.item1;
    int lastCol = _context.nextActiveUnitLastSearchCell.item2;

    for (int r = lastRow + 1; r < _context.gameField.rows; r++) {
      for (int c = lastCol + 1; c < _context.gameField.cols; c++) {
        if (_checkCell(r, c, events)) break;
      }
    }

    if (events.isEmpty) {
      for (int r = 0; r <= lastRow; r++) {
        for (int c = 0; c < lastCol; c++) {
          if (_checkCell(r, c, events)) break;
        }
      }
    }

    if (events.isNotEmpty) {
      _context.updateGameObjectsEvent.update(events);
    }

    return currentState;
  }

  bool _checkCell(int row, int col, List<UpdateGameEvent> events) {
    final cell = _context.gameField.getCell(row, col);

    if (cell.nation == _context.myNation &&
        cell.units.isNotEmpty &&
        cell.units.first.state != UnitState.disabled) {

      events.add(MoveCameraToCell(cell));
      _context.nextActiveUnitLastSearchCell = Tuple2(row, col);

      return true;
    }

    return false;
  }
}
