part of game_field_sm;

class FromTurnEndConfirmationNeededOnUserConfirmed {
  final GameFieldStateMachineContext _context;

  FromTurnEndConfirmationNeededOnUserConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();
    return TurnIsEnded();
  }
}