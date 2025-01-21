import 'package:test/test.dart';
import 'package:trench_warfare/core/entities/hex_matrix/hex_matrix_library.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';

import 'assert.dart';

class TestHexMatrixItem extends HexMatrixItem {
  TestHexMatrixItem({required super.row, required super.col});
}

class TestHexMatrix extends HexMatrix<TestHexMatrixItem> {
  TestHexMatrix(super.cellsRaw, {required super.rows, required super.cols});
}

TestHexMatrix _createHexMatrix() {
  const rows = 7;
  const cols = 7;

  final List<TestHexMatrixItem> cells = [];
  for (var i = 0; i < rows; i++) {
    for (var j = 0; j < cols; j++) {
      cells.add(TestHexMatrixItem(row: i, col: j));
    }
  }

  return TestHexMatrix(cells, rows: rows, cols: cols);
}

void main() {
  group('HexMatrix normal cases', () {
    test('start row is odd', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 12);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 2 && e.col == 4)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 2 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 3 && e.col == 5)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 4 && e.col == 5)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 5 && e.col == 4)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 5 && e.col == 3)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 5 && e.col == 2)!);
      Assert.isTrue(result.elementAt(7).let((e) => e.row == 4 && e.col == 1)!);
      Assert.isTrue(result.elementAt(8).let((e) => e.row == 3 && e.col == 1)!);

      Assert.isTrue(result.elementAt(9).let((e) => e.row == 2 && e.col == 1)!);
      Assert.isTrue(result.elementAt(10).let((e) => e.row == 2 && e.col == 2)!);
      Assert.isTrue(result.elementAt(11).let((e) => e.row == 1 && e.col == 3)!);
    });

    test('start row is even', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(2, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 12);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 1 && e.col == 4)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 1 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 2 && e.col == 5)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 3 && e.col == 5)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 4 && e.col == 4)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 4 && e.col == 3)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 4 && e.col == 2)!);
      Assert.isTrue(result.elementAt(7).let((e) => e.row == 3 && e.col == 1)!);
      Assert.isTrue(result.elementAt(8).let((e) => e.row == 2 && e.col == 1)!);

      Assert.isTrue(result.elementAt(9).let((e) => e.row == 1 && e.col == 1)!);
      Assert.isTrue(result.elementAt(10).let((e) => e.row == 1 && e.col == 2)!);
      Assert.isTrue(result.elementAt(11).let((e) => e.row == 0 && e.col == 3)!);
    });
  });

  group('HexMatrix radius cases', () {
    test('the radius is zero', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 0);

      // Assert
      Assert.isTrue(result.isEmpty);
    });

    test('the radius is 1', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 1);

      // Assert
      Assert.isTrue(result.length == 6);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 3 && e.col == 4)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 4 && e.col == 4)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 4 && e.col == 3)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 4 && e.col == 2)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 3 && e.col == 2)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 2 && e.col == 3)!);
    });

    test('the radius is extra large', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 10);

      // Assert
      Assert.isTrue(result.isEmpty);
    });
  });

  group('HexMatrix corner cases', () {
    test('left-top corner', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(0, 0);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 4);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 0 && e.col == 2)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 1 && e.col == 2)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 1 && e.col == 1)!);
      Assert.isTrue(result.elementAt(3).let((e) => e.row == 2 && e.col == 0)!);
    });

    test('right-top corner', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(0, 6);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 4);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 2 && e.col == 6)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 1 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 1 && e.col == 4)!);
      Assert.isTrue(result.elementAt(3).let((e) => e.row == 0 && e.col == 4)!);
    });

    test('right-bottom corner', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(6, 6);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 4);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 6 && e.col == 4)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 5 && e.col == 4)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 4 && e.col == 5)!);
      Assert.isTrue(result.elementAt(3).let((e) => e.row == 4 && e.col == 6)!);
    });

    test('left-bottom corner', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(6, 0);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 4);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 4 && e.col == 1)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 5 && e.col == 2)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 6 && e.col == 2)!);
      Assert.isTrue(result.elementAt(3).let((e) => e.row == 4 && e.col == 0)!);
    });
  });

  group('HexMatrix side cases', () {
    test('top side', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(0, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 7);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 0 && e.col == 5)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 1 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 2 && e.col == 4)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 2 && e.col == 3)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 2 && e.col == 2)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 1 && e.col == 1)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 0 && e.col == 1)!);
    });

    test('right side', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 6);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 7);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 5 && e.col == 6)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 4 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 4 && e.col == 4)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 3 && e.col == 4)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 2 && e.col == 4)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 1 && e.col == 5)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 1 && e.col == 6)!);
    });

    test('bottom side', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(6, 3);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 7);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 5 && e.col == 4)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 5 && e.col == 5)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 6 && e.col == 5)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 6 && e.col == 1)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 5 && e.col == 1)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 5 && e.col == 2)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 4 && e.col == 3)!);
    });

    test('left side', () {
      // Arrange
      final matrix = _createHexMatrix();
      final centralCell = matrix.getCell(3, 0);

      // Act
      final result = matrix.findCellsAroundR(centralCell, radius: 2);

      // Assert
      Assert.isTrue(result.length == 7);

      Assert.isTrue(result.elementAt(0).let((e) => e.row == 1 && e.col == 1)!);
      Assert.isTrue(result.elementAt(1).let((e) => e.row == 2 && e.col == 2)!);
      Assert.isTrue(result.elementAt(2).let((e) => e.row == 3 && e.col == 2)!);

      Assert.isTrue(result.elementAt(3).let((e) => e.row == 4 && e.col == 2)!);
      Assert.isTrue(result.elementAt(4).let((e) => e.row == 4 && e.col == 1)!);
      Assert.isTrue(result.elementAt(5).let((e) => e.row == 5 && e.col == 0)!);

      Assert.isTrue(result.elementAt(6).let((e) => e.row == 1 && e.col == 0)!);
    });
  });
}
