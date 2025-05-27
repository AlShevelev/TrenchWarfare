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

class FromSettingsAreVisibleOnSettingsClosed {
  final GameFieldStateMachineContext _context;

  FromSettingsAreVisibleOnSettingsClosed(this._context);

  State process(SettingsResult result) {
    TransitionUtils(_context).closeUI();
    
    _context.animationTimeFacade.updateTime(result);

    return ReadyForInput();
  }
}