import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:tuple/tuple.dart';

enum DamageType {
  explosion,
  bloodSplash,
  gasAttack,
  flame,
  propaganda,
}

sealed class UpdateGameEvent {}

class UpdateCell implements UpdateGameEvent {
  final GameFieldCell cell;

  final Iterable<GameFieldCell> updateBorderCells;

  UpdateCell(this.cell, {required this.updateBorderCells});
}

class UpdateCellInactivity implements UpdateGameEvent {
  final Map<int, GameFieldCellRead> newInactiveCells;

  final Map<int, GameFieldCellRead> oldInactiveCells;

  UpdateCellInactivity({required this.newInactiveCells, required this.oldInactiveCells});
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

class ShowComplexDamage implements UpdateGameEvent {
  final Iterable<Tuple2<GameFieldCellRead, DamageType>> cells;

  /// Animation time in [ms]
  final int time;

  ShowComplexDamage({
    required this.cells,
    required this.time,
  });
}

class AnimationCompleted implements UpdateGameEvent {}
