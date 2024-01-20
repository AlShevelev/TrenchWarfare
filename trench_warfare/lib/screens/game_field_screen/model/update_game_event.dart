import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

sealed class UpdateGameEvent {}

class UpdateObjects implements UpdateGameEvent {
  final Iterable<GameFieldCell> cells;

  UpdateObjects(this.cells);
}

class UpdateObject implements UpdateGameEvent {
  final GameFieldCell cell;

  UpdateObject(this.cell);
}