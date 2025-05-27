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

class FromReadyForInputOnLongClickEnd {
  late final GameFieldStateMachineContext _context;

  FromReadyForInputOnLongClickEnd(this._context);

  State process() {
    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}
