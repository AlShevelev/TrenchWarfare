/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_objects;

class TerrainModifier extends GameObject {
  final TerrainModifierType type;

  bool get isLand => type != TerrainModifierType.seaMine;

  TerrainModifier({
    required this.type,
  });
}
