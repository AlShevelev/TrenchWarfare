import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/shared/utils/range.dart';

abstract class GameObject {}

///
class ProductionCenter extends GameObject {
  final ProductionCenterType type;
  final ProductionCenterLevel level;
  final String name;

  bool get isLand => type != ProductionCenterType.navalBase;

  ProductionCenter({
    required this.type,
    required this.level,
    required this.name,
  });
}

///
class TerrainModifier extends GameObject {
  final TerrainModifierType type;

  bool get isLand => type != TerrainModifierType.seaMine;

  TerrainModifier({
    required this.type,
  });
}

///
class Unit extends GameObject {
  final UnitBoost? boost1;
  final UnitBoost? boost2;
  final UnitBoost? boost3;

  final UnitExperienceRank experienceRank;

  late final int tookPartInBattles;

  final double fatigue;

  late final double health;
  double get maxHealth => _getMaxHealth();

  late final double movementPoints;
  double get maxMovementPoints => _getMaxMovementPoints();

  double get attack => _getAttack();
  double get defence => _getDefence();

  Range<double> get damage => _getDamage();

  final UnitType unitType;

  bool get isLand =>
      unitType == UnitType.armoredCar ||
      unitType == UnitType.artillery ||
      unitType == UnitType.infantry ||
      unitType == UnitType.cavalry ||
      unitType == UnitType.machineGunnersCart ||
      unitType == UnitType.machineGuns ||
      unitType == UnitType.tank;

  Unit({
    required this.boost1,
    required this.boost2,
    required this.boost3,
    required this.experienceRank,
    required this.fatigue,
    required double health,
    required double movementPoints,
    required this.unitType,
  }) {
    tookPartInBattles = _calculateTookPartInBattles();
    this.health = maxHealth * health;
    this.movementPoints = movementPoints * maxMovementPoints;
  }

  int _calculateTookPartInBattles() {
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

  double _getMaxHealth() {
    switch (unitType) {
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
    switch (unitType) {
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
    switch (unitType) {
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
    switch (unitType) {
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
    switch (unitType) {
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

///
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
    required super.unitType,
    required this.units,
  });
}
