part of game_objects;

class Unit extends GameObject {
  late final String id;

  UnitBoost? _boost1;
  UnitBoost? get boost1 => _boost1;

  UnitBoost? _boost2;
  UnitBoost? get boost2 => _boost2;

  UnitBoost? _boost3;
  UnitBoost? get boost3 => _boost3;

  UnitExperienceRank get experienceRank => calculateExperienceRank(_tookPartInBattles);

  late int _tookPartInBattles;
  int get tookPartInBattles => _tookPartInBattles;

  /// [0, 1], where 1 is well rested
  late double _fatigue;
  double get fatigue => _fatigue;

  double get maxFatigue => 1;

  late double _health;
  double get health => _health;

  double get maxHealth => Unit._getMaxHealth(type);

  late double _movementPoints;
  double get movementPoints => _movementPoints;

  double get maxMovementPoints => Unit._getMaxMovementPoints(type) * (hasBoost(UnitBoost.transport) ? 2 : 1);

  double get attack => _getAttack();

  late double _defence;
  double get defence => _defence;

  Range<double> get damage => _getDamage();

  late final UnitType _type;
  UnitType get type => _type;

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

  bool get isShip =>
      type == UnitType.destroyer ||
      type == UnitType.cruiser ||
      type == UnitType.battleship ||
      type == UnitType.carrier;

  bool get hasMachineGun =>
      type == UnitType.armoredCar ||
      type == UnitType.machineGunnersCart ||
      type == UnitType.machineGuns ||
      type == UnitType.tank;

  bool get hasArtillery =>
      type == UnitType.artillery ||
      type == UnitType.tank ||
      type == UnitType.destroyer ||
      type == UnitType.cruiser ||
      type == UnitType.battleship;

  /// [fatigue] - from 0 to 1 (where 1 is well rested)
  /// [health] - from 0 to 1
  /// [movementPoints] - from 0 to 1
  Unit({
    required UnitBoost? boost1,
    required UnitBoost? boost2,
    required UnitBoost? boost3,
    required UnitExperienceRank experienceRank,
    required double fatigue,
    required double health,
    required double movementPoints,
    required UnitType type,
  }) {
    _type = type;

    id = RandomGen.generateId();

    _boost1 = _boost1;
    _boost2 = _boost2;
    _boost3 = _boost3;

    _tookPartInBattles = _calculateStartTookPartInBattlesValue(experienceRank);
    _health = _getMaxHealth(type) * health;
    _fatigue = fatigue;

    _defence = _getDefence();

    _movementPoints = movementPoints * _getMaxMovementPoints(type) * (hasBoost(UnitBoost.transport) ? 2 : 1);

    _state = movementPoints == 0 ? UnitState.disabled : UnitState.enabled;
  }

  Unit.byType(UnitType type) {
    _type = type;

    id = RandomGen.generateId();

    _boost1 = null;
    _boost2 = null;
    _boost3 = null;

    _tookPartInBattles = _calculateStartTookPartInBattlesValue(UnitExperienceRank.rookies);
    _health = _getMaxHealth(type);
    _fatigue = 1;   // well rested

    _defence = _getDefence();

    _movementPoints = _getMaxMovementPoints(type);

    _state = UnitState.enabled;
  }

  Unit.copy(Unit unit) {
    _boost1 = unit.boost1;
    _boost2 = unit.boost2;
    _boost3 = unit.boost3;
    _tookPartInBattles = unit._tookPartInBattles;
    _health = unit._health;
    _fatigue = unit._fatigue;
    _defence = unit._defence;
    _movementPoints = unit._movementPoints;
    _state = unit._state;
    _type = unit.type;
  }

  void setState(UnitState state) => _state = state;

  void setMovementPoints(double movementPoints) => _movementPoints = movementPoints;

  void setHealth(double health) => _health = health;

  void setFatigue(double fatigue) => _fatigue = fatigue;

  void setDefence(double defence) => _defence = defence;

  void setTookPartInBattles(int tookPartInBattles) => _tookPartInBattles = tookPartInBattles;

  void setBoost1(UnitBoost boost) {
    _boost1 = boost;
    _movementPoints *= hasBoost(UnitBoost.transport) ? 2 : 1;
  }

  void setBoost2(UnitBoost boost) {
    _boost2 = boost;
    _movementPoints *= hasBoost(UnitBoost.transport) ? 2 : 1;
  }

  void setBoost3(UnitBoost boost) {
    _boost3 = boost;
    _movementPoints *= hasBoost(UnitBoost.transport) ? 2 : 1;
  }

  bool hasBoost(UnitBoost boost) => _boost1 == boost || _boost2 == boost || _boost3 == boost;

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

  static double _getMaxHealth(UnitType type) {
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
        return 10;
      case UnitType.cruiser:
        return 15;
      case UnitType.battleship:
        return 25;
      case UnitType.carrier:
        return 25;
    }
  }

  static double _getMaxMovementPoints(UnitType type) {
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
        return 3;
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
        return 5;
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
