part of game_objects;

class Carrier extends Unit {
  final Iterable<Unit> units;

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

  static Unit createEmpty() =>
      Carrier(
          boost1: null,
          boost2: null,
          boost3: null,
          experienceRank: UnitExperienceRank.rookies,
          fatigue: 0,
          health: 0,
          movementPoints: 0,
          type: UnitType.carrier,
          units: [],
      );
}
