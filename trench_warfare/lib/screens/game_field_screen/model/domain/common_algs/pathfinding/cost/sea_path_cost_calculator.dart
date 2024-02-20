import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/entities/path_item.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/path_item_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';

class SeaPathCostCalculator {
  late final Iterable<GameFieldCell> _sourcePath;

  @protected
  Unit get activeUnit => _sourcePath.first.activeUnit!;

  @protected
  Nation get nation => _sourcePath.first.nation!;

  SeaPathCostCalculator(Iterable<GameFieldCell> sourcePath) {
    _sourcePath = sourcePath;
  }

  Iterable<GameFieldCell> calculate() {
    var movementPointsLeft = activeUnit.movementPoints;

    for (var cell in _sourcePath) {
      if (cell == _sourcePath.first) {
        cell.setPathItem(PathItem(
          type: PathItemType.normal,
          isActive: movementPointsLeft >= 0,
          movementPointsLeft: movementPointsLeft,
        ));
        continue;
      }

      final pathItemType = getPathItemType(cell, cell == _sourcePath.last);

      if (mustResetMovementPoints(cell) && movementPointsLeft > 0) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= getMoveToCellCost(cell);
      }

      cell.setPathItem(PathItem(
        type: pathItemType,
        isActive: movementPointsLeft >= 0,
        movementPointsLeft: movementPointsLeft,
      ));
    }

    return _sourcePath;
  }

  bool isEndOfPathReachable() {
    var movementPointsLeft = activeUnit.movementPoints;

    for (var cell in _sourcePath) {
      if (cell == _sourcePath.first) {
        continue;
      }

      if (mustResetMovementPoints(cell) && movementPointsLeft > 0) {
        movementPointsLeft = 0;
      } else {
        movementPointsLeft -= getMoveToCellCost(cell);
      }
    }

    return movementPointsLeft >= 0;
  }

  @protected
  PathItemType getPathItemType(GameFieldCell nextCell, bool isLast) {
    if (isMineField(nextCell)) {
      return PathItemType.explosion;
    }

    if (isBattleCell(nextCell)) {
      return PathItemType.battle;
    }

    if (isLast) {
      return PathItemType.end;
    }

    return PathItemType.normal;
  }

  @protected
  bool mustResetMovementPoints(GameFieldCell nextCell) {
    if (isMineField(nextCell)) {
      return true;
    }

    if (isBattleCell(nextCell)) {
      return true;
    }

    return false;
  }

  @protected
  double getMoveToCellCost(GameFieldCell nextCell) => 1;

  @protected
  bool isBattleCell(GameFieldCell cell) => cell.activeUnit != null && cell.nation != nation;

  @protected
  bool isMineField(GameFieldCell cell) => cell.terrainModifier?.type == TerrainModifierType.seaMine;
}
