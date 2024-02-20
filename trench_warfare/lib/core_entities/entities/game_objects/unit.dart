part of game_objects;

class Unit extends GameObject {
  late final String id;

  final UnitBoost? boost1;
  final UnitBoost? boost2;
  final UnitBoost? boost3;

  UnitExperienceRank get experienceRank => calculateExperienceRank(_tookPartInBattles);

  late int _tookPartInBattles;
  int get tookPartInBattles => _tookPartInBattles;

  late double _fatigue;
  double get fatigue => _fatigue;

  late double _health;
  double get health => _health;

  double get maxHealth => _getMaxHealth();

  late double movementPoints;
  double get maxMovementPoints => _getMaxMovementPoints();

  double get attack => _getAttack();
  double get defence => _getDefence();

  Range<double> get damage => _getDamage();

  final UnitType type;

  UnitState _state = UnitState.enabled;
  UnitState get state => _state;

  bool get isLand =>
      type == UnitType.armoredCar ||
      type == UnitType.artillery ||
      type == UnitType.infantry ||
      type == UnitType.cavalry ||
      type == UnitType.machineGunnersCart ||
      type == UnitType.machineGuns ||
      type == UnitType.tank;

  /// Non flash & blood unit
  bool get isMechanical =>
      type == UnitType.armoredCar ||
      type == UnitType.artillery ||
      type == UnitType.tank ||
      type == UnitType.destroyer ||
      type == UnitType.cruiser ||
      type == UnitType.battleship ||
      type == UnitType.carrier;

  bool get hasMachineGun =>
      type == UnitType.armoredCar || type == UnitType.machineGunnersCart || type == UnitType.machineGuns || type == UnitType.tank;

  bool get hasArtillery =>
      type == UnitType.artillery ||
      type == UnitType.tank ||
      type == UnitType.destroyer ||
      type == UnitType.cruiser ||
      type == UnitType.battleship;

  Unit({
    required this.boost1,
    required this.boost2,
    required this.boost3,
    required UnitExperienceRank experienceRank,
    required double fatigue,
    required double health,
    required double movementPoints,
    required this.type,
  }) {
    id = RandomGen.generateId();

    _tookPartInBattles = _calculateStartTookPartInBattlesValue(experienceRank);
    _health = maxHealth * health;
    _fatigue = fatigue;

    this.movementPoints = movementPoints * maxMovementPoints;
  }

  void setState(UnitState state) => _state = state;

  void setMovementPoints(double movementPoints) => this.movementPoints = movementPoints;

  void setHealth(double health) => _health = health;

  void setFatigue(double fatigue) => _fatigue = fatigue;

  void setTookPartInBattles(int tookPartInBattles) => _tookPartInBattles = tookPartInBattles;

  int _calculateStartTookPartInBattlesValue(UnitExperienceRank experienceRank) {
    switch (experienceRank) {
      case UnitExperienceRank.rookies:
        return 0;
      case UnitExperienceRank.fighters:
        return 1;
      case UnitExperienceRank.proficients:
        return 3;
      case UnitExperienceRank.veterans:
        return 6;
      case UnitExperienceRank.elite:
        return 10;
    }
  }

  static UnitExperienceRank calculateExperienceRank(int tookPartInBattles) {
    if (tookPartInBattles == 0) {
      return UnitExperienceRank.rookies;
    }

    if (tookPartInBattles >= 1 && tookPartInBattles < 3) {
      return UnitExperienceRank.fighters;
    }

    if (tookPartInBattles >= 3 && tookPartInBattles < 6) {
      return UnitExperienceRank.proficients;
    }

    if (tookPartInBattles >= 6 && tookPartInBattles < 10) {
      return UnitExperienceRank.veterans;
    }

    return UnitExperienceRank.elite;
  }

  double _getMaxHealth() {
    switch (type) {
      case UnitType.armoredCar:
        return 8;
      case UnitType.artillery:
        return 5;
      case UnitType.infantry:
        return 5;
      case UnitType.cavalry:
        return 6;
      case UnitType.machineGunnersCart:
        return 6;
      case UnitType.machineGuns:
        return 5;
      case UnitType.tank:
        return 10;
      case UnitType.destroyer:
        return 15;
      case UnitType.cruiser:
        return 25;
      case UnitType.battleship:
        return 50;
      case UnitType.carrier:
        return 15;
    }
  }

  double _getMaxMovementPoints() {
    switch (type) {
      case UnitType.armoredCar:
        return 3;
      case UnitType.artillery:
        return 1;
      case UnitType.infantry:
        return 2;
      case UnitType.cavalry:
        return 4;
      case UnitType.machineGunnersCart:
        return 3;
      case UnitType.machineGuns:
        return 1;
      case UnitType.tank:
        return 2;
      case UnitType.destroyer:
        return 4;
      case UnitType.cruiser:
        return 3;
      case UnitType.battleship:
        return 2;
      case UnitType.carrier:
        return 1;
    }
  }

  double _getAttack() {
    switch (type) {
      case UnitType.armoredCar:
        return 3;
      case UnitType.artillery:
        return 5;
      case UnitType.infantry:
        return 1;
      case UnitType.cavalry:
        return 2;
      case UnitType.machineGunnersCart:
        return 3;
      case UnitType.machineGuns:
        return 3;
      case UnitType.tank:
        return 4;
      case UnitType.destroyer:
        return 5;
      case UnitType.cruiser:
        return 8;
      case UnitType.battleship:
        return 12;
      case UnitType.carrier:
        return 0;
    }
  }

  double _getDefence() {
    switch (type) {
      case UnitType.armoredCar:
        return 5;
      case UnitType.artillery:
        return 1;
      case UnitType.infantry:
        return 1;
      case UnitType.cavalry:
        return 2;
      case UnitType.machineGunnersCart:
        return 3;
      case UnitType.machineGuns:
        return 1;
      case UnitType.tank:
        return 8;
      case UnitType.destroyer:
        return 8;
      case UnitType.cruiser:
        return 10;
      case UnitType.battleship:
        return 20;
      case UnitType.carrier:
        return 8;
    }
  }

  Range<double> _getDamage() {
    switch (type) {
      case UnitType.armoredCar:
        return Range(3, 4);
      case UnitType.artillery:
        return Range(3, 6);
      case UnitType.infantry:
        return Range(1, 3);
      case UnitType.cavalry:
        return Range(1, 3);
      case UnitType.machineGunnersCart:
        return Range(2, 3);
      case UnitType.machineGuns:
        return Range(2, 3);
      case UnitType.tank:
        return Range(5, 6);
      case UnitType.destroyer:
        return Range(5, 6);
      case UnitType.cruiser:
        return Range(8, 10);
      case UnitType.battleship:
        return Range(14, 16);
      case UnitType.carrier:
        return Range(0, 0);
    }
  }
}
