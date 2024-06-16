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

    _setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
