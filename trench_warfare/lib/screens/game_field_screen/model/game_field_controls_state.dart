import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class Visible extends GameFieldControlsState {
  final int money;
  final int industryPoints;

  final GameFieldControlsCellInfo? cellInfo;

  Visible({required this.cellInfo, required this.money, required this.industryPoints});
}

class GameFieldControlsCellInfo {
  final int money;
  final int industryPoints;

  final CellTerrain terrain;

  final TerrainModifierType? terrainModifier;

  final ProductionCenter? productionCenter;

  final List<Unit>? army;

  GameFieldControlsCellInfo({
    required this.money,
    required this.industryPoints,
    required this.terrain,
    required this.terrainModifier,
    required this.productionCenter,
    required this.army,
  });
}
