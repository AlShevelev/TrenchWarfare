import 'package:flame/components.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/entities/path_item.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

abstract interface  class GameFieldCellRead {
  /// Center of the cell in map coordinates
  final Vector2 center = Vector2.zero();

  final int row = 0;
  final int col = 0;

  late final String id;

  final CellTerrain terrain = CellTerrain.water;

  final bool hasRiver = false;
  final bool hasRoad = false;

  Nation? get nation;

  ProductionCenter? get productionCenter;

  TerrainModifier? get terrainModifier;

  PathItem? get pathItem;

  Iterable<Unit> get units;

  Unit? get activeUnit;

  bool get isLand;

  bool get isEmpty;
}

class GameFieldCell implements GameFieldCellRead {
  /// Center of the cell in map coordinates
  @override
  final Vector2 center;

  @override
  final int row;
  @override
  final int col;

  @override
  late final String id;

  @override
  final CellTerrain terrain;

  @override
  final bool hasRiver;
  @override
  final bool hasRoad;

  Nation? _nation;
  @override
  Nation? get nation => _nation;

  ProductionCenter? _productionCenter;
  @override
  ProductionCenter? get productionCenter => _productionCenter;

  TerrainModifier? _terrainModifier;
  @override
  TerrainModifier? get terrainModifier => _terrainModifier;

  PathItem? _pathItem;
  @override
  PathItem? get pathItem => _pathItem;

  late final List<Unit> _units;
  @override
  Iterable<Unit> get units => _units;

  @override
  Unit? get activeUnit => _units.firstOrNull;

  @override
  bool get isLand => terrain != CellTerrain.water;

  @override
  bool get isEmpty => productionCenter == null && terrainModifier == null && units.isEmpty;

  GameFieldCell({
    required this.terrain,
    required this.hasRiver,
    required this.hasRoad,
    required this.center,
    required this.row,
    required this.col,
  }) {
    id = RandomGen.generateId();
    _units = [];
  }

  void setNation(Nation nation) {
    _nation = nation;
  }

  void setProductionCenter(ProductionCenter? productionCenter) {
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

  void addUnitAsActive(Unit unit) {
    _units.insert(0, unit);
  }

  void addUnits(Iterable<Unit> units) {
    _units.addAll(units);
  }

  Unit removeActiveUnit() =>  _units.removeAt(0);
}
