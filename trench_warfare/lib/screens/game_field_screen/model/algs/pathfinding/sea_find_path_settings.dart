import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/find_path.dart';

class SeaFindPathSettings implements FindPathSettings {
  late final GameFieldCell _startCell;

  SeaFindPathSettings({required GameFieldCell startCell,}) {
    _startCell = startCell;
  }

  @override
  double? calculateGFactorHeuristic(GameFieldCell priorCell, GameFieldCell nextCell) {
    if (!isCellReachable(nextCell)) {
      return null;
    } else {
      return 1;
    }
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
