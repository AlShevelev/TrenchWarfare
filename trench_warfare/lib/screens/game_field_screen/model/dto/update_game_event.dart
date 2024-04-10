import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';

enum DamageType {
  explosion,
  bloodSplash,
}

sealed class UpdateGameEvent {}

class UpdateCell implements UpdateGameEvent {
  final GameFieldCell cell;

  final Iterable<GameFieldCell> updateBorderCells;

  UpdateCell(this.cell, {required this.updateBorderCells});
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

class ShowDamage implements UpdateGameEvent {
  final GameFieldCell cell;

  final DamageType damageType;

  /// Animation time in [ms]
  final int time;

  ShowDamage({required this.cell, required this.damageType, required this.time});
}

class ShowDualDamage implements UpdateGameEvent {
  final GameFieldCell cell1;
  final DamageType damageType1;

  final GameFieldCell cell2;
  final DamageType damageType2;

  /// Animation time in [ms]
  final int time;

  ShowDualDamage({
    required this.cell1,
    required this.damageType1,
    required this.cell2,
    required this.damageType2,
    required this.time,
  });
}

class MovementCompleted implements UpdateGameEvent {}
