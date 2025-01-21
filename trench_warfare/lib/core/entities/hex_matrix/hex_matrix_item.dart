part of hex_matrix;

abstract class HexMatrixItem {
  final int row;
  final int col;

  late final int id;

  HexMatrixItem({
    required this.row,
    required this.col,
  }) {
    id = pair(row, col);
  }
}