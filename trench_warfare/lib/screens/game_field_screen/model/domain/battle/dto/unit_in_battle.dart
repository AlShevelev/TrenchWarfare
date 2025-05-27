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

class UnitInBattle {
  final UnitType type;

  final Range<double> damage;

  double _attack;
  double get attack => _attack;

  double _defence;
  double get defence => _defence;

  UnitExperienceRank get experienceRank => Unit.calculateExperienceRank(_tookPartInBattles);

  int _tookPartInBattles;
  int get tookPartInBattles => _tookPartInBattles;

  double _fatigue;
  double get fatigue => _fatigue;

  final double healthBeforeBattle;

  double _health;
  double get health => _health;

  final double maxHealth;

  final bool isMechanical;

  bool _hasMachineGun;
  bool get hasMachineGun => _hasMachineGun;

  bool _hasArtillery;
  bool get hasArtillery => _hasArtillery;

  bool _takeHalfDamage;
  bool get takeHalfDamage => _takeHalfDamage;

  UnitInBattle({
    required this.type,
    required this.damage,
    required double attack,
    required double defence,
    required int tookPartInBattles,
    required double fatigue,
    required this.healthBeforeBattle,
    required double health,
    required this.maxHealth,
    required this.isMechanical,
    required bool hasMachineGun,
    required bool hasArtillery,
    required bool takeHalfDamage,
  })  : _tookPartInBattles = tookPartInBattles,
        _fatigue = fatigue,
        _health = health,
        _hasArtillery = hasArtillery,
        _hasMachineGun = hasMachineGun,
        _defence = defence,
        _attack = attack,
        _takeHalfDamage = takeHalfDamage;

  void updateAttack(double valueToAdd) => _attack *= valueToAdd;

  void updateDefence(double valueToAdd) => _defence *= valueToAdd;

  void updateHasArtillery(bool hasArtillery) => _hasArtillery = hasArtillery;

  void updateHasMachineGun(bool hasMachineGun) => _hasMachineGun = hasMachineGun;

  void reduceHealth(double valueToReduce) => _health -= valueToReduce * (_takeHalfDamage ? 0.5 : 1.0);

  void setTakeHalfDamage(bool takeHalfDamage) => _takeHalfDamage = takeHalfDamage;

  void reduceFatigue(double valueToReduce) {
    _fatigue -= valueToReduce;

    if (fatigue < 0) {
      _fatigue = 0;
    }
  }

  void increaseTookPartInBattles(int valueToIncrease) => _tookPartInBattles += valueToIncrease;

  @override
  String toString() =>
      'UNIT_IN_BATTLE: {type: $type; level: $experienceRank; health: $health; fatigue: $fatigue}';
}
