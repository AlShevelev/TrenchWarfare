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

class FromSaveSlotSelectionOnSaveSlotSelected {
  final GameFieldStateMachineContext _context;

  final GameSlot _slot;

  FromSaveSlotSelectionOnSaveSlotSelected(this._context, GameSlot slot) : _slot = slot;

  State process() {
    _context.modelCallback.saveGame(_slot);

    TransitionUtils(_context).closeUI();

    return ReadyForInput();
  }
}