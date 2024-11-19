part of game_field_sm;

class FromReadyForInputOnLongClickEnd {
  late final GameFieldStateMachineContext _context;

  FromReadyForInputOnLongClickEnd(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}
