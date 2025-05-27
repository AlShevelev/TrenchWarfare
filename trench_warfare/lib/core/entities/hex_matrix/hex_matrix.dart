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

abstract class HexMatrix<T extends HexMatrixItem> {
  /// A quantity of the rows
  final int rows;

  /// A quantity of the cols
  final int cols;

  @protected
  final List<T> cellsRaw;

  HexMatrix(this.cellsRaw, {required this.rows, required this.cols});

  T getCell(int row, int col) => cellsRaw[getCellIndex(row, col)];

  int getCellIndex(int row, int col) => cols * row + col;

  T getCellById(int id) => cellsRaw.where((c) => c.id == id).first;

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  Iterable<T?> findAllCellsAround(T centralCell) {
    return <T?>[
      _findCellAround(centralCell, HexMatrixItemPlace.topRight),
      _findCellAround(centralCell, HexMatrixItemPlace.bottomRight),
      _findCellAround(centralCell, HexMatrixItemPlace.bottom),
      _findCellAround(centralCell, HexMatrixItemPlace.bottomLeft),
      _findCellAround(centralCell, HexMatrixItemPlace.topLeft),
      _findCellAround(centralCell, HexMatrixItemPlace.top),
    ];
  }

  /// Returns all cells except the cells out of the field
  Iterable<T> findCellsAround(T centralCell) =>
      findAllCellsAround(centralCell).where((e) => e != null).map((e) => e!).toList();

  /// Returns all cells (except the cells out of the field)
  /// around started from top-right in the radius, clockwise
  /// [radius] is in interval [1, N]
  Iterable<T> findCellsAroundR(T centralCell, {required int radius}) {
    final result = <T>[];

    if (radius <= 0) {
      return result;
    }

    if (radius == 1) {
      return findCellsAround(centralCell);
    }

    // Looking for the start point - the top one
    var startRow = centralCell.row;
    var startCol = centralCell.col;
    for (var i = 0; i < radius; i++) {
      startRow = _findRowForCellAround(startRow, startCol, HexMatrixItemPlace.top);
      startCol = _findColForCellAround(startCol, HexMatrixItemPlace.top);
    }

    final directionsOfBypass = [
      HexMatrixItemPlace.bottomRight,
      HexMatrixItemPlace.bottom,
      HexMatrixItemPlace.bottomLeft,
      HexMatrixItemPlace.topLeft,
      HexMatrixItemPlace.top,
      HexMatrixItemPlace.topRight,
    ];

    var currentRow = startRow;
    var currentCol = startCol;
    for (var directionsOfBypass in directionsOfBypass) {
      for (var i = 0; i < radius; i++) {
        currentRow = _findRowForCellAround(currentRow, currentCol, directionsOfBypass);
        currentCol = _findColForCellAround(currentCol, directionsOfBypass);

        if (_isInsideMatrix(row: currentRow, col: currentCol)) {
          result.add(getCell(currentRow, currentCol));
        }
      }
    }

    return result;
  }

  /// Calculates a logical (in terms of rows and cols) distance between the cells
  double calculateDistance(T cell1, T cell2) =>
      math.sqrt(math.pow(cell1.row - cell2.row, 2) + math.pow(cell1.col - cell2.col, 2));

  bool _isInsideMatrix({required int row, required int col}) {
    final rowRange = Range(0, rows - 1);
    final colRange = Range(0, cols - 1);

    return rowRange.isInRange(row, minIncluded: true) && colRange.isInRange(col, minIncluded: true);
  }

  T? _findCellAround(T centralCell, HexMatrixItemPlace place) {
    final row = _findRowForCellAround(centralCell.row, centralCell.col, place);
    final col = _findColForCellAround(centralCell.col, place);

    return _isInsideMatrix(row: row, col: col) ? getCell(row, col) : null;
  }

  int _findRowForCellAround(
    int centralCellRow,
    int centralCellCol,
    HexMatrixItemPlace place,
  ) =>
      switch (place) {
        HexMatrixItemPlace.topRight => centralCellCol % 2 == 0 ? centralCellRow - 1 : centralCellRow,
        HexMatrixItemPlace.bottomRight => centralCellCol % 2 == 0 ? centralCellRow : centralCellRow + 1,
        HexMatrixItemPlace.bottom => centralCellRow + 1,
        HexMatrixItemPlace.bottomLeft => centralCellCol % 2 == 0 ? centralCellRow : centralCellRow + 1,
        HexMatrixItemPlace.topLeft => centralCellCol % 2 == 0 ? centralCellRow - 1 : centralCellRow,
        HexMatrixItemPlace.top => centralCellRow - 1,
      };

  int _findColForCellAround(int centralCellCol, HexMatrixItemPlace place) => switch (place) {
        HexMatrixItemPlace.topRight => centralCellCol + 1,
        HexMatrixItemPlace.bottomRight => centralCellCol + 1,
        HexMatrixItemPlace.bottom => centralCellCol,
        HexMatrixItemPlace.bottomLeft => centralCellCol - 1,
        HexMatrixItemPlace.topLeft => centralCellCol - 1,
        HexMatrixItemPlace.top => centralCellCol,
      };
}
