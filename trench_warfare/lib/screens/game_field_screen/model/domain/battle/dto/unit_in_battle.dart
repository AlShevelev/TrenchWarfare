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
  })  : _tookPartInBattles = tookPartInBattles,
        _fatigue = fatigue,
        _health = health,
        _hasArtillery = hasArtillery,
        _hasMachineGun = hasMachineGun,
        _defence = defence,
        _attack = attack;

  void updateAttack(double updateFactor) => _attack *= updateFactor;

  void updateDefence(double updateFactor) => _defence *= updateFactor;

  void updateHasArtillery(bool hasArtillery) => _hasArtillery = hasArtillery;

  void updateHasMachineGun(bool hasMachineGun) => _hasMachineGun = hasMachineGun;

  void reduceHealth(double valueToReduce) => _health -= valueToReduce;

  void increaseHealth(double valueToIncrease) => _health += valueToIncrease;

  void reduceFatigue(double valueToReduce) {
    _fatigue -= valueToReduce;

    if (fatigue < 0) {
      _fatigue = 0;
    }
  }

  void increaseTookPartInBattles(int valueToIncrease) => _tookPartInBattles += valueToIncrease;
}
