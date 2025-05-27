/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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

  final Nation nation;

  final List<Unit> units;

  GameFieldControlsArmyInfo({
    required this.cellId,
    required this.nation,
    required this.units,
  });
}
