part of game_field_sm;

class FromInitialOnOnStarTurnTransition extends GameObjectTransitionBase {
  FromInitialOnOnStarTurnTransition(super.context);

  State process() {
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    List<UpdateGameEvent> events = [];

    final cellsToAdd = _context.gameField.cells.where((c) => c.nation != null);
    events.addAll(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));
    events.add(MoveCameraToCell(_context.gameField.cells.firstWhere((c) => c.nation == _context.nation)));

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
