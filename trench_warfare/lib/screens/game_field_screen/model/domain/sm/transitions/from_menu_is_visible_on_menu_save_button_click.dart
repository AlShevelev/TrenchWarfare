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

class FromMenuIsVisibleOnMenuSaveButtonClick {
  final GameFieldStateMachineContext _context;

  FromMenuIsVisibleOnMenuSaveButtonClick(GameFieldStateMachineContext context) : _context = context;

  State process() {
    _context.controlsState.update(SaveControls());

    return SaveSlotSelection();
  }
}
