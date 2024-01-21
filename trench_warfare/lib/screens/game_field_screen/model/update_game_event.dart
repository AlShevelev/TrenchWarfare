import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

sealed class UpdateGameEvent {}

class UpdateObject implements UpdateGameEvent {
  final GameFieldCell cell;

  UpdateObject(this.cell);
}