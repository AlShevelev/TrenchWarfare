import 'dart:ui';

import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/entities/path_item.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class GameFieldCell {
  /// Center of the cell in map coordinates
  final Offset center;

  final int row;
  final int col;

  int get id => pair(row, col);

  final CellTerrain terrain;

  final bool hasRiver;
  final bool hasRoad;

  Nation? _nation;
  Nation? get nation => _nation;

  ProductionCenter? _productionCenter;
  ProductionCenter? get productionCenter => _productionCenter;

  TerrainModifier? _terrainModifier;
  TerrainModifier? get terrainModifier => _terrainModifier;

  PathItem? _pathItem;
  PathItem? get pathItem => _pathItem;

  late final List<Unit> _units;
  Iterable<Unit> get units => _units;

  Unit? get activeUnit => _units.firstOrNull;

  bool get isLand => terrain != CellTerrain.water;

  bool get isEmpty => nation == null && productionCenter == null && terrainModifier == null && units.isEmpty;

  GameFieldCell({
    required this.terrain,
    required this.hasRiver,
    required this.hasRoad,
    required this.center,
    required this.row,
    required this.col,
  }) {
    _units = [];
  }

  void setNation(Nation nation) {
    _nation = nation;
  }

  void setProductionCenter(ProductionCenter productionCenter) {
    _productionCenter = productionCenter;
  }

  void setTerrainModifier(TerrainModifier? terrainModifier) {
    _terrainModifier = terrainModifier;
  }

  void setPathItem(PathItem? pathItem) {
    _pathItem = pathItem;
  }

  void addUnit(Unit unit) {
    _units.add(unit);
  }

  void addUnits(Iterable<Unit> units) {
    _units.addAll(units);
  }
}
