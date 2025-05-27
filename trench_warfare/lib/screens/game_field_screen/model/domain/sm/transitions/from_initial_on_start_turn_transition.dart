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

class FromInitialOnStarTurnTransition {
  final GameFieldStateMachineContext _context;

  FromInitialOnStarTurnTransition(this._context);

  State process() {
    if (_context.dayStorage.day == 0) {
      _context.dayStorage.increaseDay();
    }

    _context.controlsState.update(StartTurnControls(
      nation: _context.myNation,
      day: _context.dayStorage.day,
    ));

    if (!_context.isAI) {
      _context.modelCallback.saveGame(GameSlot.autoSave);
    }

    return StartTurnInitialConfirmation();
  }
}
