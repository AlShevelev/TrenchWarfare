import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';

/// Looks for a cell by some position on a map
class FindCellByPosition {
  static GameFieldCell findCell(Iterable<GameFieldCell> cells, Vector2 position) {
    var minDistance = double.maxFinite;
    GameFieldCell? targetCell;

    for (var cell in cells) {
      final distance = math.sqrt(math.pow(cell.center.dx - position.x, 2) + math.pow(cell.center.dy - position.y, 2));

      if (distance < minDistance) {
        minDistance = distance;
        targetCell = cell;
      }
    }

    return targetCell!;
  }
}