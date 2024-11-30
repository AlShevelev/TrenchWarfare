part of game_field;

abstract interface class GameFieldRead {
  final int rows = 0;
  final int cols = 0;

  Iterable<GameFieldCell> get cells;

  GameFieldCell getCell(int row, int col);

  GameFieldCell getCellById(int id);

  int getCellIndex(int row, int col);

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  Iterable<GameFieldCell?> findAllCellsAround(GameFieldCellRead centralCell);

  /// Returns all cells except out of the field
  Iterable<GameFieldCell> findCellsAround(GameFieldCellRead centralCell);

  Iterable<GameFieldCell> findCellsAroundR(GameFieldCellRead centralCell, {required int radius});

  /// Looks for a cell by some position on a map
  GameFieldCell findCellByPosition(Vector2 position);

  /// Calculates a logical (in terms of rows and cols) distance between the cells
  double calculateDistance(GameFieldCellRead cell1, GameFieldCellRead cell2);

  GameFieldCellRead? getCellWithUnit(Unit unit, Nation nation);
}

class GameField extends HexMatrix<GameFieldCell> implements GameFieldRead {
  @override
  Iterable<GameFieldCell> get cells => cellsRaw;

  GameField(super._cells, {required super.rows, required super.cols});

  /// Returns  all cells around started from top-right, clockwise
  /// Out of the field cells are returned as null
  @override
  Iterable<GameFieldCell?> findAllCellsAround(GameFieldCellRead centralCell) =>
      super.findAllCellsAround(centralCell as GameFieldCell);

  /// Returns all cells except out of the field
  @override
  Iterable<GameFieldCell> findCellsAround(GameFieldCellRead centralCell) =>
      super.findCellsAround(centralCell as GameFieldCell);

  /// Returns all cells (except the cells out of the field)
  /// around started from top-right in the radius, clockwise
  /// [radius] is in interval [1, N]
  @override
  Iterable<GameFieldCell> findCellsAroundR(GameFieldCellRead centralCell, {required int radius}) =>
      super.findCellsAroundR(centralCell as GameFieldCell, radius: radius);

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

  /// Calculates a logical (in terms of rows and cols) distance between the cells
  @override
  double calculateDistance(GameFieldCellRead cell1, GameFieldCellRead cell2) =>
      super.calculateDistance(cell1 as GameFieldCell, cell2  as GameFieldCell);

  @override
  GameFieldCellRead? getCellWithUnit(Unit unit, Nation nation) =>
    cells.firstWhereOrNull((c) => c.nation == nation && c.units.isNotEmpty && c.units.contains(unit));
}