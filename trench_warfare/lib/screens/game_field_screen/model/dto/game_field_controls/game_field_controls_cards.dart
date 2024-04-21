part of game_field_controls;

abstract interface class BuildPossibility {
  final bool canBuildByCurrency = false;
  final bool canBuildByIndustryPoint = false;
  final BuildRestriction? buildDisplayRestriction = null;
  final BuildRestriction? buildError = null;
}
abstract class GameFieldControlsCard implements BuildPossibility { }

class GameFieldControlsUnitCard extends GameFieldControlsCard {
  final MoneyUnit cost;

  final UnitType type;

  final int maxHealth;

  final int attack;
  final int defence;

  final Range<int> damage;

  final double movementPoints;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsUnitCard({
    required this.cost,
    required this.type,
    required this.maxHealth,
    required this.attack,
    required this.defence,
    required this.damage,
    required this.movementPoints,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });
}

class GameFieldControlsProductionCentersCard extends GameFieldControlsCard {
  final MoneyUnit cost;

  final ProductionCenterType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsProductionCentersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });
}

class GameFieldControlsTerrainModifiersCard extends GameFieldControlsCard {
  final MoneyUnit cost;

  final TerrainModifierType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsTerrainModifiersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });
}

class GameFieldControlsUnitBoostersCard extends GameFieldControlsCard {
  final MoneyUnit cost;

  final UnitBoost type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsUnitBoostersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });
}

class GameFieldControlsSpecialStrikesCard extends GameFieldControlsCard {
  final MoneyUnit cost;

  final SpecialStrikeType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsSpecialStrikesCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });
}
