part of game_field_controls;

abstract interface class BuildPossibility {
  final bool canBuildByCurrency = false;
  final bool canBuildByIndustryPoint = false;
  final bool canBuildOnGameField = false;
}

class GameFieldControlsUnitCard implements BuildPossibility {
  final MoneyUnit cost;

  final UnitType type;

  final int maxHealth;

  final int attack;
  final int defence;

  final Range<int> damage;

  final double movementPoints;

  final BuildRestriction buildRestriction;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final bool canBuildOnGameField;

  GameFieldControlsUnitCard({
    required this.cost,
    required this.type,
    required this.maxHealth,
    required this.attack,
    required this.defence,
    required this.damage,
    required this.movementPoints,
    required this.buildRestriction,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.canBuildOnGameField,
  });
}

class GameFieldControlsProductionCentersCard {
  GameFieldControlsProductionCentersCard();
}

class GameFieldControlsTerrainModifiersCard implements BuildPossibility {
  final MoneyUnit cost;

  final TerrainModifierType type;

  final BuildRestriction buildRestriction;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final bool canBuildOnGameField;

  GameFieldControlsTerrainModifiersCard({
    required this.cost,
    required this.type,
    required this.buildRestriction,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.canBuildOnGameField,
  });
}

class GameFieldControlsUnitBoostersCard implements BuildPossibility {
  final MoneyUnit cost;

  final UnitBoost type;

  final BuildRestriction buildRestriction;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final bool canBuildOnGameField;

  GameFieldControlsUnitBoostersCard({
    required this.cost,
    required this.type,
    required this.buildRestriction,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.canBuildOnGameField,
  });
}

class GameFieldControlsSpecialStrikesCard implements BuildPossibility {
  final MoneyUnit cost;

  final SpecialStrikeType type;

  final BuildRestriction buildRestriction;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final bool canBuildOnGameField;

  GameFieldControlsSpecialStrikesCard({
    required this.cost,
    required this.type,
    required this.buildRestriction,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.canBuildOnGameField,
  });
}
