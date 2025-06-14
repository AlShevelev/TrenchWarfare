/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of battle;

sealed class UnitBattleResult {}

class Died extends UnitBattleResult {
  @override
  String toString() => 'DIED';
}

class Alive extends UnitBattleResult {
  final UnitInBattle info;

  Alive(this.info);

  @override
  String toString() => 'ALIVE: {info: $info}';
}

class InPanic extends UnitBattleResult {
  final UnitInBattle info;

  InPanic(this.info);

  @override
  String toString() => 'IN_PANIC: {info: $info}';
}

class UnitsBattleResult {
  final UnitBattleResult attacking;
  final UnitBattleResult defending;

  UnitsBattleResult({required this.attacking, required this.defending});
}
