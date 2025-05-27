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

class FromReadyForInputOnMenuButtonClick {
  final GameFieldStateMachineContext _context;

  FromReadyForInputOnMenuButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(MenuControls(
      nation: _context.myNation,
      day: _context.dayStorage.day,
    ));

    return MenuIsVisible();
  }
}
