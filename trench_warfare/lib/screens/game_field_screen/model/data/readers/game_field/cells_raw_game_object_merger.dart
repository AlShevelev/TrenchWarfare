import 'dart:math' as math;

import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/dto/game_object_raw.dart';

class CellsRawGameObjectMerger {
  static Map<GameFieldCell, CellOwnershipRaw> merge(List<GameFieldCell> cells, Map<int, GameObjectRaw> objects) {
    final Map<GameFieldCell, CellOwnershipRaw> result = {};

    objects.entries.map((e) => e.value).whereType<CellOwnershipRaw>().forEach((e) {
      result[_getNearestCell(cells, e)] = e;
    });

    return result;
  }

  static GameFieldCell _getNearestCell(List<GameFieldCell> cells, GameObjectRaw object) {
    var minDistance = double.maxFinite;
    GameFieldCell? targetCell;

    for (var cell in cells) {
      final distance = math.sqrt(math.pow(cell.center.x - object.center.x, 2) + math.pow(cell.center.y - object.center.y, 2));

      if (distance < minDistance) {
        minDistance = distance;
        targetCell = cell;
      }
    }

    return targetCell!;
  }
}
