import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_object.dart';
import 'package:trench_warfare/core_entities/entities/path_item.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/path_item_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';

class SeaPathCostCalculator {
  late final Iterable<GameFieldCell> _sourcePath;

  Unit get _activeUnit => _sourcePath.first.activeUnit!;

  Nation get _nation => _sourcePath.first.nation!;

  SeaPathCostCalculator(Iterable<GameFieldCell> sourcePath) {
    _sourcePath = sourcePath;
  }

  Iterable<GameFieldCell> calculate() {
    var movementPointsLeft = _activeUnit.movementPoints;

    for (var cell in _sourcePath) {
      if (cell == _sourcePath.first) {
        cell.setPathItem(PathItem(
          type: PathItemType.normal,
          isActive: movementPointsLeft >= 0,
          movementPointsLeft: movementPointsLeft,
        ));
        continue;
      }

      final pathItemType = _getPathItemType(cell, cell == _sourcePath.last);

      if (_mustResetMovementPoints(cell)) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= _getMoveToCellCost(cell);
      }

      cell.setPathItem(PathItem(
        type: pathItemType,
        isActive: movementPointsLeft >= 0,
        movementPointsLeft: movementPointsLeft,
      ));
    }

    return _sourcePath;
  }

  PathItemType _getPathItemType(GameFieldCell nextCell, bool isLast) {
    if (nextCell.terrainModifier?.type == TerrainModifierType.seaMine) {
      return PathItemType.explosion;
    }

    if (nextCell.activeUnit != null && nextCell.nation != _nation) {
      return PathItemType.battle;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  bool _mustResetMovementPoints(GameFieldCell nextCell) => false;

  double _getMoveToCellCost(GameFieldCell nextCell) => 1;
}
