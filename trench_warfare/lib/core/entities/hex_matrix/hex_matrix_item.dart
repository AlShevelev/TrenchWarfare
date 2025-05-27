/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of hex_matrix;

abstract class HexMatrixItem {
  final int row;
  final int col;

  late final int id;

  HexMatrixItem({
    required this.row,
    required this.col,
  }) {
    id = InGameMath.pair(row, col);
  }
}