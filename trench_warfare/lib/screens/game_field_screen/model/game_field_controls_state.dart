import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class MainControls extends GameFieldControlsState {
  final MoneyUnit money;

  final GameFieldControlsCellInfo? cellInfo;

  final GameFieldControlsArmyInfo? armyInfo;

  MainControls({
    required this.money,
    required this.cellInfo,
    required this.armyInfo,
  });
}

class Cards extends GameFieldControlsState {
  final MoneyUnit money;

  Cards({
    required this.money,
  });
}

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
  final String cellId;

  final List<Unit> units;

  GameFieldControlsArmyInfo({
    required this.cellId,
    required this.units,
  });
}
