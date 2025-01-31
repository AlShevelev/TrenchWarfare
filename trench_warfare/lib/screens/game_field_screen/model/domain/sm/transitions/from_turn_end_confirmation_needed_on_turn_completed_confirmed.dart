part of game_field_sm;

class FromTurnEndConfirmationNeededOnTurnCompletedConfirmed {
  final GameFieldStateMachineContext _context;

  FromTurnEndConfirmationNeededOnTurnCompletedConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();
    return TurnIsEnded();
  }
}