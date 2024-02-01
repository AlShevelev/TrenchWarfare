import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';

class MovementWithoutObstaclesCalculator {
  static const int _unitMovementTime = 100; // [ms]
  static const int _unitMovementPause = 100; // [ms]

  late final Nation _nation;
  late final GameFieldReadOnly _gameField;
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementWithoutObstaclesCalculator({
    required Nation nation,
    required GameFieldReadOnly gameField,
    required SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _nation = nation;
    _gameField = gameField;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  /// Move from the start to the end without obstacles
  State startMovement(Iterable<GameFieldCell> path) {
    final unit = path.first.removeActiveUnit();

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();
    final lastReachableCell = reachableCells.last;

    for (var cell in reachableCells) {
      cell.setNation(_nation);
    }

    lastReachableCell.addUnitAsActive(unit);
    unit.setMovementPoints(lastReachableCell.pathItem!.movementPointsLeft);

    if (unit.movementPoints > 0) {
      final state = _canMove(startCell: lastReachableCell, isLandUnit: unit.isLand) ? UnitState.enabled : UnitState.disabled;
      unit.setState(state);
    } else {
      unit.setState(UnitState.disabled);
    }

    for (var cell in path) {
      cell.setPathItem(null);
    }

    // Here we must update UI
    var updateEvents = [
      CreateUntiedUnit(path.first, unit),
      UpdateObject(path.first),
    ];

    GameFieldCell? priorCell;
    for (var cell in reachableCells) {
      if (cell != reachableCells.first) {
        updateEvents.add(MoveUntiedUnit(startCell: priorCell!, endCell: cell, unit: unit, time: _unitMovementTime));
        updateEvents.add(UpdateObject(cell));
        updateEvents.add(Pause(_unitMovementPause));
      }
      priorCell = cell;
    }

    updateEvents.add(RemoveUntiedUnit(unit));

    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateObject(cell));
      }
    }

    updateEvents.add(MovementCompleted());
    _updateGameObjectsEvent.update(updateEvents);

    return MovingInProgress();
  }

  bool _canMove({
    required GameFieldCell startCell,
    required bool isLandUnit,
  }) =>
      PathFacade(isLandUnit, _gameField).canMove(startCell);
}
