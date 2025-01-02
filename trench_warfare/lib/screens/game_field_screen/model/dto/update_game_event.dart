import 'package:flame/game.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
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

  ShowDamage({
    required this.cell,
    required this.damageType,
    required this.time,
  });
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

class SetCamera implements UpdateGameEvent {
  final double? zoom;

  final Vector2? position;

  SetCamera(this.zoom, this.position);
}

class MoveCameraToCell implements UpdateGameEvent {
  final GameFieldCellRead cell;

  MoveCameraToCell(this.cell);
}

class PlaySound implements UpdateGameEvent {
  /// Type of sound to play
  final SoundType type;

  /// Duration of the sound to play (null - without restriction)
  final int? duration;

  /// The playing strategy
  final SoundStrategy strategy;

  /// If the sound with the same type is played or in the queue - do nothing
  final bool ignoreIfPlayed;

  PlaySound({
    required this.type,
    this.duration,
    this.strategy = SoundStrategy.interrupt,
    this.ignoreIfPlayed = true,
  });
}
