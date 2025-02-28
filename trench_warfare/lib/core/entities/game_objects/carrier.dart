part of game_objects;

class Carrier extends Unit {
  late final List<Unit> _units;
  Iterable<Unit> get units => _units;

  bool get hasUnits => _units.isNotEmpty;

  bool get hasPlaceForUnit => _units.length < GameConstants.maxUnitsInCarrier;

  Unit? get activeUnit => _units.firstOrNull;

  /// [fatigue] - from 0 to 1 (where 1 is well rested)
  /// [health] - from 0 to 1
  /// [movementPoints] - from 0 to 1
  Carrier({
    super.boost1,
    super.boost2,
    super.boost3,
    required super.fatigue,
    required super.health,
    required super.movementPoints,
    required List<Unit> units,
  }) : super(
          experienceRank: UnitExperienceRank.rookies,
          type: UnitType.carrier,
        ) {
    _units = units;
  }

  Carrier.copy(Carrier carrier)
      : super(
          boost1: carrier.boost1,
          boost2: carrier.boost2,
          boost3: carrier.boost3,
          experienceRank: carrier.experienceRank,
          fatigue: carrier.fatigue,
          health: carrier.health,
          movementPoints: carrier.movementPoints,
          type: carrier.type,
        ) {
    _tookPartInBattles = carrier._tookPartInBattles;
    _health = carrier._health;
    _fatigue = carrier._fatigue;
    _movementPoints = carrier.movementPoints;
    _state = carrier._state;

    _units = carrier._units.map((u) => Unit.copy(u)).toList(growable: true);
  }

  Carrier.restoreAfterSaving({
    required super.id,
    required super.boost1,
    required super.boost2,
    required super.boost3,
    required super.tookPartInBattles,
    required super.fatigue,
    required super.health,
    required super.movementPoints,
    required super.defence,
    required super.type,
    required super.state,
    required super.isInDefenceMode,
  }) : super.restoreAfterSaving() {
    _units = [];
  }

  @override
  void setTookPartInBattles(int tookPartInBattles) => super.setTookPartInBattles(0);

  void resortUnits(Iterable<String> unitsId) {
    final result = List<Unit>.empty(growable: true);

    for (var unitId in unitsId) {
      result.add(_units.singleWhere((u) => u.id == unitId));
    }

    _units.clear();
    _units.addAll(result);
  }

  void addUnitAsActive(Unit unit) {
    _units.insert(0, unit);
  }

  void addUnits(Iterable<Unit> units) {
    _units.clear();
    _units.addAll(units);
  }

  Unit removeActiveUnit() => _units.removeAt(0);

  static Carrier create() => Carrier(
        boost1: null,
        boost2: null,
        boost3: null,
        fatigue: 1.0, // well rested
        health: 1.0, // max health
        movementPoints: 1.0, // max movement points
        units: [],
      );

  @override
  String toString() => 'CARRIER: {id: $id; state: $state; boost1: $boost1; boost2: $boost2; boost3: $boost3; '
      'level: $experienceRank; health: $health; movementPoints: $movementPoints; units: ${units.length}}';
}
