/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field;

abstract interface class GameFieldCellRead {
  /// Center of the cell in map coordinates
  final Vector2 center = Vector2.zero();

  final int row = 0;
  final int col = 0;

  late final int id;

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

  String toStringBrief();
}

class GameFieldCell extends HexMatrixItem implements GameFieldCellRead {
  /// Center of the cell in map coordinates
  @override
  final Vector2 center;

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
    required super.row,
    required super.col,
  }) {
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

  void makeActiveUnitLast() {
    if (_units.isNotEmpty && _units.length > 1) {
      _units.add(_units.removeAt(0));
    }
  }

  Unit removeActiveUnit() => _units.removeAt(0);

  void removeUnit(Unit unit) => _units.remove(unit);

  void removeUnits(Iterable<Unit> units) {
    for (final unit in units) {
      removeUnit(unit);
    }
  }

  void resortUnits(Iterable<String> unitsId) {
    final result = List<Unit>.empty(growable: true);

    for (var unitId in unitsId) {
      result.add(_units.singleWhere((u) => u.id == unitId));
    }

    _units.clear();
    _units.addAll(result);
  }

  void clear() {
    _nation = null;
    _units.clear();
    _terrainModifier = null;
    _productionCenter = null;
    _pathItem = null;
  }

  @override
  String toString() =>
      'CELL: {id: $id; row: $row; col: $col; units: ${units.length}; terrain: $terrain; '
          'terrainModifier: ${terrainModifier?.type}; '
          'production: [type: ${productionCenter?.type}; level: ${productionCenter?.level}]; '
          'hasRoad: $hasRoad; hasRiver: $hasRiver}; pathItem: $pathItem; nation: $_nation';

  @override
  String toStringBrief() => 'CELL: {id: $id; row: $row; col: $col';
}
