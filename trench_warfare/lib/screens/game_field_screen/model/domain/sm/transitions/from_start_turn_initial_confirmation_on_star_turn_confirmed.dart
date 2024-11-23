part of game_field_sm;

class FromStartTurnInitialConfirmationOnStarTurnConfirmed {
  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromStartTurnInitialConfirmationOnStarTurnConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    List<UpdateGameEvent> events = [];

    // A human player plays first - so we can make a global initialization for this player only
    if (!_context.isAI) {
      final cellsToAdd = _context.gameField.cells.where((c) =>
          c.nation != null &&
          // The cell has some game objects or we need to draw borders
          (!c.isEmpty ||
              _context.gameField.findCellsAround(c).any((cellAround) => cellAround.nation != c.nation)));
      events.addAll(cellsToAdd.map((c) => InitCell(c, drawBorder: c.nation == _context.nation)));
    }

    _transitionUtils.setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
