part of game_field_sm;

class FromStartTurnInitialConfirmationOnStarTurnConfirmed extends GameObjectTransitionBase {
  FromStartTurnInitialConfirmationOnStarTurnConfirmed(super.context);

  State process() {
    TransitionUtils(_context).closeUI();

    List<UpdateGameEvent> events = [];

    final cellsToAdd = _context.gameField.cells.where((c) => c.nation != null);
    events.addAll(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));

    _setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
