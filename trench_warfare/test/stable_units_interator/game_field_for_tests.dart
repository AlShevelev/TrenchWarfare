import 'package:flame/components.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';

class GameFieldForTests implements GameFieldRead {
  @override
  int get cols => throw UnimplementedError();

  @override
  int get rows => throw UnimplementedError();

  @override
  final Iterable<GameFieldCell> cells;


  GameFieldForTests({required this.cells});

  @override
  double calculateDistance(GameFieldCellRead cell1, GameFieldCellRead cell2) {
    throw UnimplementedError();
  }

  @override
  Iterable<GameFieldCell?> findAllCellsAround(GameFieldCellRead centralCell) {
    throw UnimplementedError();
  }

  @override
  GameFieldCell findCellByPosition(Vector2 position) {
    throw UnimplementedError();
  }

  @override
  Iterable<GameFieldCell> findCellsAround(GameFieldCellRead centralCell) {
    throw UnimplementedError();
  }

  @override
  Iterable<GameFieldCell> findCellsAroundR(GameFieldCellRead centralCell, {required int radius}) {
    throw UnimplementedError();
  }

  @override
  GameFieldCell getCell(int row, int col) {
    throw UnimplementedError();
  }

  @override
  GameFieldCell getCellById(int id) {
    throw UnimplementedError();
  }

  @override
  int getCellIndex(int row, int col) {
    throw UnimplementedError();
  }

  @override
  GameFieldCellRead? getCellWithUnit(Unit unit, Nation nation) {
    throw UnimplementedError();
  }
}
