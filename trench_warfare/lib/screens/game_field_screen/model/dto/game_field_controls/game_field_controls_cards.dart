part of game_field_controls;

class GameFieldControlsUnitCard {
  final MoneyUnit cost;

  final UnitType type;

  final int maxHealth;

  final int attack;
  final int defence;

  final Range<int> damage;

  final double movementPoints;

  GameFieldControlsUnitCard({
    required this.cost,
    required this.type,
    required this.maxHealth,
    required this.attack,
    required this.defence,
    required this.damage,
    required this.movementPoints,
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
