part of game_field_sm;

class FromReadyForInputOnEndOfTurnButtonClick {
  final GameFieldStateMachineContext _context;

  FromReadyForInputOnEndOfTurnButtonClick(this._context);

  State process() => TransitionUtils(_context).processEndOfTurn();
}
