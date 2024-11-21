part of game_field_sm;

class FromStartTurnInitialConfirmationOnStarTurnConfirmed {
  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromStartTurnInitialConfirmationOnStarTurnConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    List<UpdateGameEvent> events = [];

    final cellsToAdd = _context.gameField.cells.where((c) => c.nation != null);
    events.addAll(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));

    _transitionUtils.setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
