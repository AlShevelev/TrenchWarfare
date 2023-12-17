import 'package:trench_warfare/core_entities/unit_boost.dart';
import 'package:trench_warfare/core_entities/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/unit_type.dart';

abstract class GameObjectRaw {}

class Nation extends GameObjectRaw {
  final Nation nation;

  Nation({required this.nation});
}

class Unit extends GameObjectRaw {
  final UnitBoost? boost1;
  final UnitBoost? boost2;
  final UnitBoost? boost3;

  final UnitExperienceRank experienceRank;

  final double fatigue;

  final double health;

  final int indexInArmy;

  final double movementPoints;

  final UnitType unit;

  Unit({
    required this.boost1,
    required this.boost2,
    required this.boost3,
    required this.experienceRank,
    required this.fatigue,
    required this.health,
    required this.indexInArmy,
    required this.movementPoints,
    required this.unit,
  });
}
