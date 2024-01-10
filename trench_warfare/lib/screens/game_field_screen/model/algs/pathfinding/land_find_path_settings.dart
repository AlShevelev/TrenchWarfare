import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/core_entities/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/find_path.dart';

class LandFindPathSettings implements FindPathSettings {
  late final GameFieldCell _startCell;

  UnitType? get _unit => _startCell.activeUnit?.unitType;

  LandFindPathSettings({required GameFieldCell startCell}) {
    _startCell = startCell;
  }

  @override
  double? calculateGFactorHeuristic(GameFieldCell priorCell, GameFieldCell nextCell) {
    if (!isCellReachable(nextCell)) {
      return null;
    }

    // Try to avoid mine fields
    final terrainModifier = nextCell.terrainModifier?.type;
    if (terrainModifier == TerrainModifierType.landMine) {
      return 8;
    }

    // Try to avoid trenches
    final nextCellIsEnemy = nextCell.nation != null && nextCell.nation != _startCell.nation;
    if (nextCellIsEnemy && terrainModifier == TerrainModifierType.trench) {
      return 8;
    }

    // Try to avoid barbed wire
    if (nextCellIsEnemy && terrainModifier == TerrainModifierType.barbedWire && _unit != UnitType.tank) {
      return 8;
    }

    // Try to avoid enemy formations
    if (nextCellIsEnemy && nextCell.units.isNotEmpty) {
      return 8;
    }

    // Try to use roads (must be checked before rivers to use bridges)
    if (nextCell.hasRoad) {
      return 1;
    }

    // Try to avoid rivers
    if (nextCell.hasRiver) {
      return 8;
    }

    // Production centers
    final productionCenter = nextCell.productionCenter?.type;
    if (productionCenter == ProductionCenterType.factory || productionCenter == ProductionCenterType.city) {
      return 1;
    }

    return _calculateForTerrain(nextCell);
  }

  @override
  bool isCellReachable(GameFieldCell cell) {
    if (!cell.isLand) {
      return false;
    }

    if (cell.nation == _startCell.nation! && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    //terrain type
    final terrain = cell.terrain;

    if (terrain == CellTerrain.marsh &&
        (_unit == UnitType.machineGunnersCart ||
            _unit == UnitType.artillery ||
            _unit == UnitType.armoredCar ||
            _unit == UnitType.tank)) {
      return false;
    }

    if (terrain == CellTerrain.mountains &&
        (_unit == UnitType.machineGuns ||
            _unit == UnitType.cavalry ||
            _unit == UnitType.machineGunnersCart ||
            _unit == UnitType.artillery ||
            _unit == UnitType.armoredCar ||
            _unit == UnitType.tank)) {
      return false;
    }

    return true;
  }

  double? _calculateForTerrain(GameFieldCell nextCell) {
    return switch (nextCell.terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (_unit) {
          UnitType.infantry => 1.25,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 2,
          UnitType.artillery => 2,
          UnitType.armoredCar => 2,
          UnitType.tank => 2,
          _ => null,
        },
      CellTerrain.marsh => switch (_unit) {
          UnitType.infantry => 2,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 2,
          _ => null,
        },
      CellTerrain.sand => switch (_unit) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 1.7,
          UnitType.artillery => 2,
          UnitType.armoredCar => 1.7,
          UnitType.tank => 1.25,
          _ => null,
        },
      CellTerrain.hills => switch (_unit) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => null,
        },
      CellTerrain.mountains => switch (_unit) { UnitType.infantry => 2, _ => null },
      CellTerrain.snow => switch (_unit) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => null,
        },
      _ => null,
    };
  }
}
