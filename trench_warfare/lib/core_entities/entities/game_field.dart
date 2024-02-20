import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

abstract class GameFieldReadOnly {
  final int rows = 0;
  final int cols = 0;

  Iterable<GameFieldCell> get cells;

  GameFieldCell getCell(int row, int col);

  GameFieldCell getCellById(String id);
}

class GameField implements GameFieldReadOnly {
  @override
  final int rows;
  @override
  final int cols;

  late final List<GameFieldCell> _cells;
  @override
  Iterable<GameFieldCell> get cells => _cells;

  GameField({required this.rows, required this.cols});

  @override
  GameFieldCell getCell(int row, int col) => _cells[_getCellIndex(row, col)];

  @override
  GameFieldCell getCellById(String id) => _cells.where((c) => c.id == id).first;

  void setCells(List<GameFieldCell> cells) {
    _cells = cells;
  }

  int _getCellIndex(int row, int col) => rows * row + col;
}
