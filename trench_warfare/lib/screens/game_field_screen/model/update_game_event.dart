import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';

sealed class UpdateGameEvent {}

class UpdateObject implements UpdateGameEvent {
  final GameFieldCell cell;

  UpdateObject(this.cell);
}

class CreateUntiedUnit implements UpdateGameEvent {
  final GameFieldCell cell;

  final Unit unit;

  CreateUntiedUnit(this.cell, this.unit);
}

class RemoveUntiedUnit implements UpdateGameEvent {
  final Unit unit;

  RemoveUntiedUnit(this.unit);
}

class MoveUntiedUnit implements UpdateGameEvent {
  final GameFieldCell startCell;
  final GameFieldCell endCell;

  final Unit unit;

  /// Moving time in [ms]
  final int time;

  MoveUntiedUnit({required this.startCell, required this.endCell, required this.unit, required this.time});
}

class Pause implements UpdateGameEvent {
  final int time;

  Pause(this.time);
}

class MovementCompleted implements UpdateGameEvent {}
