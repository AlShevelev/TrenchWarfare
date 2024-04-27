part of game_objects;

class Carrier extends Unit {
  final Iterable<Unit> units;

  /// [fatigue] - from 0 to 1 (where 1 is well rested)
  /// [health] - from 0 to 1
  /// [movementPoints] - from 0 to 1
  Carrier({
    required super.boost1,
    required super.boost2,
    required super.boost3,
    required super.experienceRank,
    required super.fatigue,
    required super.health,
    required super.movementPoints,
    required super.type,
    required this.units,
  });

  static Unit create() =>
      Carrier(
        boost1: null,
        boost2: null,
        boost3: null,
        experienceRank: UnitExperienceRank.rookies,
        fatigue: 1, // well rested
        health: 1,  // max health
        movementPoints: 1, // max movement points
        type: UnitType.carrier,
        units: [],
      );
}
