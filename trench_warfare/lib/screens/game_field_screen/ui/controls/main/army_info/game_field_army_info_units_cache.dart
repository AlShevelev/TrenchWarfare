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

mixin GameFieldArmyInfoUnitsCache {
  final Map<String, Picture> _cachedUnitPictures = {};

  Picture? getUnitPicture(String key) => _cachedUnitPictures[key];

  void putUnitPicture(String key, Picture picture) => _cachedUnitPictures.addAll({key: picture});
}