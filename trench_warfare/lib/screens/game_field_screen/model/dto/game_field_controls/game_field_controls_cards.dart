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

class GameFieldControlsTerrainModifiersCard {
  GameFieldControlsTerrainModifiersCard();
}

class GameFieldControlsTroopBoostersCard {
  GameFieldControlsTroopBoostersCard();
}

class GameFieldControlsSpecialStrikesCard {
  GameFieldControlsSpecialStrikesCard();
}
