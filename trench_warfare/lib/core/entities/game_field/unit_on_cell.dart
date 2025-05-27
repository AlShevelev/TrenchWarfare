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

class UnitOnCell {
  final GameFieldCellRead cell;

  final Unit unit;

  UnitOnCell({required this.cell, required this.unit});
}