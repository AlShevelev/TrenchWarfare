import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/dto/game_field_cell.dart';

abstract class GameFieldReadOnly {
  final int rows = 0;
  final int cols = 0;

  Iterable<GameFieldCell?> get cells;

  GameFieldCell getCell(int row, int col);
}

class GameField implements GameFieldReadOnly {
  @override
  final int rows;
  @override
  final int cols;

  late final List<GameFieldCell?> _cells;
  @override
  Iterable<GameFieldCell?> get cells => _cells;

  GameField({required this.rows, required this.cols}) {
    _cells = List.filled(rows * cols, null);
  }

  @override
  GameFieldCell getCell(int row, int col) => _cells[_getCellIndex(row, col)]!;

  void setCell(int row, int col, GameFieldCell cell) => setCellByIndex(_getCellIndex(row, col), cell);

  void setCellByIndex(int index, GameFieldCell cell) {
    _cells[index] = cell;
  }

  int _getCellIndex(int row, int col) => rows * row + col;
}
