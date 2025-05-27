/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of navigation;

class NewGameToGameFieldNavArg {
  final String mapName;

  final Nation selectedNation;

  NewGameToGameFieldNavArg({required this.mapName, required this.selectedNation});
}