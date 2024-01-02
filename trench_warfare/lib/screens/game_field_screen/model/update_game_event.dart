import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

sealed class UpdateGameEvent {}

class AddObjects implements UpdateGameEvent {
  final Iterable<GameFieldCell> cells;

  AddObjects(this.cells);
}