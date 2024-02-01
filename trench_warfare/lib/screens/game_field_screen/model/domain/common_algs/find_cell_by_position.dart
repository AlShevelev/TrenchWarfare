import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

/// Looks for a cell by some position on a map
class FindCellByPosition {
  static GameFieldCell find(GameFieldReadOnly gameField, Vector2 position) {
    var minDistance = double.maxFinite;
    GameFieldCell? targetCell;

    for (var cell in gameField.cells) {
      final distance = math.sqrt(math.pow(cell.center.x - position.x, 2) + math.pow(cell.center.y - position.y, 2));

      if (distance < minDistance) {
        minDistance = distance;
        targetCell = cell;
      }
    }

    return targetCell!;
  }
}