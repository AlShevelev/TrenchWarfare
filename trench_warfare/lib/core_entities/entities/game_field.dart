import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

import '../../shared/utils/range.dart';

abstract interface class GameFieldRead {
  final int rows = 0;
  final int cols = 0;

  Iterable<GameFieldCell> get cells;

  GameFieldCell getCell(int row, int col);

  GameFieldCell getCellById(String id);

  int getCellIndex(int row, int col);

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  Iterable<GameFieldCell?> findAllCellsAround(GameFieldCellRead centralCell);

  /// Returns all cells except out of the field
  Iterable<GameFieldCell> findCellsAround(GameFieldCellRead centralCell);

  /// Looks for a cell by some position on a map
  GameFieldCell findCellByPosition(Vector2 position);
}

class GameField implements GameFieldRead {
  @override
  final int rows;
  @override
  final int cols;

  late final List<GameFieldCell> _cells;
  @override
  Iterable<GameFieldCell> get cells => _cells;

  GameField({required this.rows, required this.cols});

  @override
  GameFieldCell getCell(int row, int col) => _cells[getCellIndex(row, col)];

  @override
  GameFieldCell getCellById(String id) => _cells.where((c) => c.id == id).first;

  void setCells(List<GameFieldCell> cells) {
    _cells = cells;
  }

  @override
  int getCellIndex(int row, int col) => rows * row + col;

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  @override
  Iterable<GameFieldCell?> findAllCellsAround(GameFieldCellRead centralCell) {
    final result = List<GameFieldCell?>.empty(growable: true);

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
  @override
  Iterable<GameFieldCell> findCellsAround(GameFieldCellRead centralCell) =>
      findAllCellsAround(centralCell).where((e) => e != null).map((e) => e!).toList();

  /// Looks for a cell by some position on a map
  @override
  GameFieldCell findCellByPosition(Vector2 position) {
    var minDistance = double.maxFinite;
    GameFieldCell? targetCell;

    for (var cell in cells) {
      final distance = math.sqrt(math.pow(cell.center.x - position.x, 2) + math.pow(cell.center.y - position.y, 2));

      if (distance < minDistance) {
        minDistance = distance;
        targetCell = cell;
      }
    }

    return targetCell!;
  }
}