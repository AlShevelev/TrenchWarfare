part of battle;

sealed class UnitBattleResult {}

class Died extends UnitBattleResult {}

class Alive extends UnitBattleResult {
  final UnitInBattle info;

  Alive(this.info);
}

class InPanic extends UnitBattleResult {
  final UnitInBattle info;

  InPanic(this.info);
}

class UnitsBattleResult {
  final UnitBattleResult attacking;
  final UnitBattleResult defending;

  UnitsBattleResult({required this.attacking, required this.defending});
}
