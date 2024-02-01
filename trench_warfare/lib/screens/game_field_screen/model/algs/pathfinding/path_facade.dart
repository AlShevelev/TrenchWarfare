import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/find_cells_around.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/find_path.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_path_cost_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/sea_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/sea_path_cost_calculator.dart';

class PathFacade {
  late final bool _isLandUnit;
  late final GameFieldReadOnly _gameField;

  PathFacade(bool isLandUnit, GameFieldReadOnly gameField) {
    _isLandUnit = isLandUnit;
    _gameField = gameField;
  }

  Iterable<GameFieldCell> calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
  }) {
    final settings = _isLandUnit ? LandFindPathSettings(startCell: startCell) : SeaFindPathSettings(startCell: startCell);

    final pathFinder = FindPath(_gameField, settings);
    return pathFinder.find(startCell, endCell);
  }

  Iterable<GameFieldCell> estimatePath({required Iterable<GameFieldCell> path}) =>
      (_isLandUnit ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).calculate();

  bool canMove(GameFieldCell cell) {
    final allCellsAround = FindCellsAround.find(_gameField, cell);

    for(var cellAround in allCellsAround) {
      final settings = _isLandUnit ? LandFindPathSettings(startCell: cell) : SeaFindPathSettings(startCell: cell);
      final path = FindPath(_gameField, settings).find(cell, cellAround);

      if (path.isEmpty) {
        continue;
      }

      if ((_isLandUnit ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).isEndOfPathReachable()) {
        return true;
      }
    }

    return false;
  }
}