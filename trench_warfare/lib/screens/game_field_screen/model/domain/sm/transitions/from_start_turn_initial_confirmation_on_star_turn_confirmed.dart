part of game_field_sm;

class FromStartTurnInitialConfirmationOnStarTurnConfirmed {
  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromStartTurnInitialConfirmationOnStarTurnConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    List<UpdateGameEvent> events = [];

    // A human player turns first, so we can init a game field for the human only
    if (!_context.isAI) {
      final cellsToAdd = _context.gameField.cells.where((c) =>
          c.nation != null && // A cell has some data or we need to draw a border
          (!c.isEmpty || _context.gameField.findCellsAround(c).any((ca) => ca.nation != c.nation)));
      events.addAll(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));
    }

    _transitionUtils.setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
