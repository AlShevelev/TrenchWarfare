part of game_objects;

class Carrier extends Unit {
  final Iterable<Unit> units;

  /// [fatigue] - from 0 to 1 (where 1 is well rested)
  /// [health] - from 0 to 1
  /// [movementPoints] - from 0 to 1
  Carrier({
    required boost1,
    required boost2,
    required boost3,
    required fatigue,
    required health,
    required movementPoints,
    required type,
    required this.units,
  }) : super(
    boost1: boost1,
    boost2: boost2,
    boost3: boost3,
    experienceRank: UnitExperienceRank.rookies,
    fatigue: fatigue,
    health: health,
    movementPoints: movementPoints,
    type: type,
  );

  @override
  void setTookPartInBattles(int tookPartInBattles) => super.setTookPartInBattles(0);

  static Unit create() =>
      Carrier(
        boost1: null,
        boost2: null,
        boost3: null,
        fatigue: 1, // well rested
        health: 1,  // max health
        movementPoints: 1, // max movement points
        type: UnitType.carrier,
        units: [],
      );
}
