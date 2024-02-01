import 'package:flame/components.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';

abstract class GameObjectRaw {
  final Vector2 center;

  final int id;

  GameObjectRaw(this.id, {required this.center});
}

class CellOwnershipRaw extends GameObjectRaw {
  final Nation nation;

  final int? productionCenterId;

  final int? terrainModifierId;

  final int? unit1Id;
  final int? unit2Id;
  final int? unit3Id;
  final int? unit4Id;

  CellOwnershipRaw(
    super.id, {
    this.productionCenterId,
    this.terrainModifierId,
    this.unit1Id,
    this.unit2Id,
    this.unit3Id,
    this.unit4Id,
    required this.nation,
    required super.center,
  });
}

class ProductionCenterRaw extends GameObjectRaw {
  final ProductionCenterType type;
  final ProductionCenterLevel level;
  final String name;

  bool get isLand => type != ProductionCenterType.navalBase;

  ProductionCenterRaw(
    super.id, {
    required this.type,
    required this.level,
    required this.name,
    required super.center,
  });
}

class TerrainModifierRaw extends GameObjectRaw {
  final TerrainModifierType type;

  bool get isLand => type != TerrainModifierType.seaMine;

  TerrainModifierRaw(
    super.id, {
    required this.type,
    required super.center,
  });
}

class UnitRaw extends GameObjectRaw {
  final UnitBoost? boost1;
  final UnitBoost? boost2;
  final UnitBoost? boost3;

  final UnitExperienceRank experienceRank;

  /// [0-1]
  final double fatigue;

  /// [0-1] - a share of a maximum health
  final double health;

  /// [0-1] - a share of a maximum movement points
  final double movementPoints;

  final UnitType unit;

  bool get isLand =>
      unit == UnitType.armoredCar ||
      unit == UnitType.artillery ||
      unit == UnitType.infantry ||
      unit == UnitType.cavalry ||
      unit == UnitType.machineGunnersCart ||
      unit == UnitType.machineGuns ||
      unit == UnitType.tank;

  UnitRaw(
    super.id, {
    required this.boost1,
    required this.boost2,
    required this.boost3,
    required this.experienceRank,
    required this.fatigue,
    required this.health,
    required this.movementPoints,
    required this.unit,
    required super.center,
  });
}

class CarrierRaw extends UnitRaw {
  final int? unit1Id;
  final int? unit2Id;
  final int? unit3Id;
  final int? unit4Id;

  CarrierRaw(
    super.id, {
    this.unit1Id,
    this.unit2Id,
    this.unit3Id,
    this.unit4Id,
    required super.boost1,
    required super.boost2,
    required super.boost3,
    required super.experienceRank,
    required super.fatigue,
    required super.health,
    required super.movementPoints,
    required super.unit,
    required super.center,
  });
}
