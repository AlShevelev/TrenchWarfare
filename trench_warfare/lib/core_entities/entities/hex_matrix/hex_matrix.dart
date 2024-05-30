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

    final rowRange = Range(0, rows - 1);
    final colRange = Range(0, cols - 1);

    // top-right
    final row4 = centralCell.row - 1;
    final col4 = centralCell.row % 2 == 0 ? centralCell.col : centralCell.col + 1;
    if (rowRange.isInRange(row4, minIncluded: true) && colRange.isInRange(col4, minIncluded: true) ) {
      result.add(getCell(row4, col4));
    } else {
      result.add(null);
    }

    // right
    final row1 = centralCell.row;
    final col1 = centralCell.col + 1;
    if (rowRange.isInRange(row1, minIncluded: true) && colRange.isInRange(col1, minIncluded: true) ) {
      result.add(getCell(row1, col1));
    } else {
      result.add(null);
    }

    // bottom-right
    final row6 = centralCell.row + 1;
    final col6 = centralCell.row % 2 == 0 ? centralCell.col : centralCell.col + 1;
    if (rowRange.isInRange(row6, minIncluded: true) && colRange.isInRange(col6, minIncluded: true) ) {
      result.add(getCell(row6, col6));
    } else {
      result.add(null);
    }

    // bottom-left
    final row5 = centralCell.row + 1;
    final col5 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col;
    if (rowRange.isInRange(row5, minIncluded: true) && colRange.isInRange(col5, minIncluded: true) ) {
      result.add(getCell(row5, col5));
    } else {
      result.add(null);
    }

    // left
    final row2 = centralCell.row;
    final col2 = centralCell.col - 1;
    if (rowRange.isInRange(row2, minIncluded: true) && colRange.isInRange(col2, minIncluded: true) ) {
      result.add(getCell(row2, col2));
    } else {
      result.add(null);
    }

    // top-left
    final row3 = centralCell.row - 1;
    final col3 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col;
    if (rowRange.isInRange(row3, minIncluded: true) && colRange.isInRange(col3, minIncluded: true) ) {
      result.add(getCell(row3, col3));
    } else {
      result.add(null);
    }

    return result;
  }

  /// Returns all cells except out of the field
  Iterable<T> findCellsAround(T centralCell) =>
      findAllCellsAround(centralCell).where((e) => e != null).map((e) => e!).toList();

  /// Calculates a logical (in terms of rows and cols) distance between the cells
  double calculateDistance(T cell1, T cell2) =>
      math.sqrt(math.pow(cell1.row - cell2.row, 2) + math.pow(cell1.col - cell2.col, 2));
}