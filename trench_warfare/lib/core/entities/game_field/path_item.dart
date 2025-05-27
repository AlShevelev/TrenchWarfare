/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field;

class PathItem {
  final PathItemType type;

  final bool isActive;

  /// How many movement point do you need to move from a previous cell to this one
  final double movementPointsLeft;

  PathItem({required this.type, required this.isActive, required this.movementPointsLeft});

  @override
  String toString() =>
      'PATH_ITEM: {type: $type; isActive: $isActive; movementPointsLeft: $movementPointsLeft}';
}
