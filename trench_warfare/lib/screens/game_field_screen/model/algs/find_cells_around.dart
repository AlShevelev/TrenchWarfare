import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/shared/utils/range.dart';

/// Looks for all cells around some cell
class FindCellsAround {
  static List<GameFieldCell> find(GameFieldReadOnly gameField, GameFieldCell centralCell) {
    final result = List<GameFieldCell>.empty(growable: true);

    final rowRange = Range(0, gameField.rows - 1);
    final colRange = Range(0, gameField.cols - 1);

    final row1 = centralCell.row;
    final col1 = centralCell.col + 1;
    if (rowRange.isInRange(row1, minIncluded: true) && colRange.isInRange(col1, minIncluded: true) ) {
      result.add(gameField.getCell(row1, col1));
    }

    final row2 = centralCell.row;
    final col2 = centralCell.col - 1;
    if (rowRange.isInRange(row2, minIncluded: true) && colRange.isInRange(col2, minIncluded: true) ) {
      result.add(gameField.getCell(row2, col2));
    }

    final row3 = centralCell.row - 1;
    final col3 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col + 1;
    if (rowRange.isInRange(row3, minIncluded: true) && colRange.isInRange(col3, minIncluded: true) ) {
      result.add(gameField.getCell(row3, col3));
    }

    final row4 = centralCell.row - 1;
    final col4 = centralCell.col;
    if (rowRange.isInRange(row4, minIncluded: true) && colRange.isInRange(col4, minIncluded: true) ) {
      result.add(gameField.getCell(row4, col4));
    }

    final row5 = centralCell.row + 1;
    final col5 = centralCell.row % 2 == 0 ? centralCell.col - 1 : centralCell.col + 1;
    if (rowRange.isInRange(row5, minIncluded: true) && colRange.isInRange(col5, minIncluded: true) ) {
      result.add(gameField.getCell(row5, col5));
    }

    final row6 = centralCell.row + 1;
    final col6 = centralCell.col;
    if (rowRange.isInRange(row6, minIncluded: true) && colRange.isInRange(col6, minIncluded: true) ) {
      result.add(gameField.getCell(row6, col6));
    }

    return result;
  }
}
