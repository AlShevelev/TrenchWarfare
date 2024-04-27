part of game_field_controls;

class GameFieldControlsCellInfo {
  final MoneyUnit income;

  final CellTerrain terrain;

  final TerrainModifierType? terrainModifier;

  final ProductionCenter? productionCenter;

  GameFieldControlsCellInfo({
    required this.income,
    required this.terrain,
    required this.terrainModifier,
    required this.productionCenter,
  });
}

class GameFieldControlsArmyInfo {
  final int cellId;

  final List<Unit> units;

  GameFieldControlsArmyInfo({
    required this.cellId,
    required this.units,
  });
}
