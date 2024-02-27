import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/find/find_path.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/find/land_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/cost/land_path_cost_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/find/sea_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/cost/sea_path_cost_calculator.dart';

class PathFacade {
  static Iterable<GameFieldCell> calculatePath({
    required GameFieldRead gameField,
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) {
    final settings = startCell.isLand ? LandFindPathSettings(startCell: startCell) : SeaFindPathSettings(startCell: startCell);

    final pathFinder = FindPath(gameField, settings);
    return pathFinder.find(startCell, endCell);
  }

  static Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) {
    if (path.isEmpty) {
      return path;
    }

    return (path.first.isLand ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).calculate();
  }

  static bool canMove(GameFieldRead gameField, GameFieldCell cell) {
    final allCellsAround = gameField.findCellsAround(cell);

    for (var cellAround in allCellsAround) {
      final settings = cell.isLand ? LandFindPathSettings(startCell: cell) : SeaFindPathSettings(startCell: cell);
      final path = FindPath(gameField, settings).find(cell, cellAround);

      if (path.isEmpty) {
        continue;
      }

      if ((cell.isLand ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }

  static Iterable<GameFieldCell> getCellsAround(GameFieldRead gameField, GameFieldCell cell) =>
      gameField.findCellsAround(cell);
}
