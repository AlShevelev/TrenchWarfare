import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/core_entities/entities/hex_matrix/hex_matrix_item.dart';
import 'package:trench_warfare/shared/utils/range.dart';

abstract class HexMatrix<T extends HexMatrixItem> {
  /// A quantity of the rows
  final int rows;

  /// A quantity of the cols
  final int cols;

  @protected
  final List<T> cellsRaw;

  HexMatrix(this.cellsRaw, {required this.rows, required this.cols});

  T getCell(int row, int col) => cellsRaw[getCellIndex(row, col)];

  int getCellIndex(int row, int col) => rows * row + col;

  T getCellById(int id) => cellsRaw.where((c) => c.id == id).first;

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  Iterable<T?> findAllCellsAround(T centralCell) {
    final result = List<T?>.empty(growable: true);

    // top-right
    final row4 = centralCell.row - 1;
    final col4 = centralCell.row % 2 == 0 ? centralCell.col : centralCell.col + 1;
    if (_isInsideMatrix(row: row4, col: col4)) {
      result.add(getCell(row4, col4));
    } else {
      result.add(null);
    }

    // right
    final row1 = centralCell.row;
    final col1 = centralCell.col + 1;
    if (_isInsideMatrix(row: row1, col: col1)) {
      result.add(getCell(row1, col1));
    } else {
      result.add(null);
    }

    // bottom-right
    final row6 = centralCell.row + 1;
    final col6 = centralCell.row % 2 == 0 ? centralCell.col : centralCell.col + 1;
    if (_isInsideMatrix(row: row6, col: col6)) {
      result.add(getCell(row6, col6));
    } else {
      result.add(null);
    }

    // bottom-left
    final row5 = centralCell.row + 1;
    final col5 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col;
    if (_isInsideMatrix(row: row5, col: col5)) {
      result.add(getCell(row5, col5));
    } else {
      result.add(null);
    }

    // left
    final row2 = centralCell.row;
    final col2 = centralCell.col - 1;
    if (_isInsideMatrix(row: row2, col: col2)) {
      result.add(getCell(row2, col2));
    } else {
      result.add(null);
    }

    // top-left
    final row3 = centralCell.row - 1;
    final col3 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col;
    if (_isInsideMatrix(row: row3, col: col3)) {
      result.add(getCell(row3, col3));
    } else {
      result.add(null);
    }

    return result;
  }

  /// Returns all cells except the cells out of the field
  Iterable<T> findCellsAround(T centralCell) =>
      findAllCellsAround(centralCell).where((e) => e != null).map((e) => e!).toList();

  /// Returns all cells (except the cells out of the field)
  /// around started from top-right in the radius, clockwise
  /// [radius] is in interval [1, N]
  Iterable<T> findCellsAroundR(T centralCell, {required int radius}) {
    final result = List<T>.empty(growable: true);

    if (radius <= 0) {
      return result;
    }

    // the top-right cell
    var baseRow = centralCell.row - radius;
    var baseCol = centralCell.col + (centralCell.row % 2 == 1 ? (radius / 2).ceil() : (radius / 2).floor());
    if (_isInsideMatrix(row: baseRow, col: baseCol)) {
      result.add(getCell(baseRow, baseCol));
    }

    // the top-right side
    for (var i = 1; i <= radius; i++) {
      var row = baseRow + i;
      var col = baseCol + (baseRow % 2 == 1 ? (i / 2).ceil() : (i / 2).floor());
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
      }

      // the right cell
      if (i == radius) {
        baseRow = row;
        baseCol = col;
      }
    }

    // the bottom-right side
    for (var i = 1; i <= radius; i++) {
      var row = baseRow + i;
      var col = baseCol - (baseRow % 2 == 1 ? (i / 2).floor() : (i / 2).ceil());
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
      }

      // the bottom-right cell
      if (i == radius) {
        baseRow = row;
        baseCol = col;
      }
    }

    // the bottom side
    for (var i = 1; i <= radius; i++) {
      var row = baseRow;
      var col = baseCol - i;
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
      }

      // the bottom-left cell
      if (i == radius) {
        baseRow = row;
        baseCol = col;
      }
    }

    // the bottom-left side
    for (var i = 1; i <= radius; i++) {
      var row = baseRow - i;
      var col = baseCol - (baseRow % 2 == 1 ? (i / 2).floor() : (i / 2).ceil());
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
      }

      // the left cell
      if (i == radius) {
        baseRow = row;
        baseCol = col;
      }
    }

    // the top-left side
    for (var i = 1; i <= radius; i++) {
      var row = baseRow - i;
      var col = baseCol + (baseRow % 2 == 1 ? (i / 2).ceil() : (i / 2).floor());
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
      }

      // the top-left cell
      if (i == radius) {
        baseRow = row;
        baseCol = col;
      }
    }

    // the top side
    for (var i = 1; i < radius; i++) {
      var row = baseRow;
      var col = baseCol + i;
      if (_isInsideMatrix(row: row, col: col)) {
        result.add(getCell(row, col));
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
}
