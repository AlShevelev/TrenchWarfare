/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

class FromTurnEndConfirmationNeededOnUserConfirmed {
  final GameFieldStateMachineContext _context;

  FromTurnEndConfirmationNeededOnUserConfirmed(this._context);

  State process() {
    TransitionUtils(_context).closeUI();
    return TurnIsEnded();
  }
}