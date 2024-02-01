import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/find_path.dart';

class SeaFindPathSettings implements FindPathSettings {
  late final GameFieldCell _startCell;

  SeaFindPathSettings({required GameFieldCell startCell}) {
    _startCell = startCell;
  }

  @override
  double? calculateGFactorHeuristic(GameFieldCell priorCell, GameFieldCell nextCell) {
    if (!isCellReachable(nextCell)) {
      return null;
    }

    // Try to avoid mine fields
    if (nextCell.terrainModifier?.type == TerrainModifierType.seaMine) {
      return 8;
    }

    // Try to avoid enemy formations
    if (nextCell.nation != null && nextCell.nation != _startCell.nation && _startCell.units.isNotEmpty) {
      return 8;
    }

    return 1;
  }

  @override
  bool isCellReachable(GameFieldCell cell) {
    if (cell.isLand && !cell.hasRiver) {
      return false;
    }

    if (cell.nation == _startCell.nation! && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    return true;
  }
}
