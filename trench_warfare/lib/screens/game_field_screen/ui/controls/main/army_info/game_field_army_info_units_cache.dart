/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_army_info;

abstract interface class GameFieldArmyInfoUnitsCache {
  Picture? getUnitPicture(String key);

  void putUnitPicture(String key, Picture picture);
}