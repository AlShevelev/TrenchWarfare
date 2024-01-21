library game_field_sm;

import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/find_path.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_path_cost_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/sea_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/sea_path_cost_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';

part 'event.dart';
part 'state.dart';

class GameFieldStateMachine implements Disposable {
  late final Nation _nation;

  late final GameFieldReadOnly _gameField;

  final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent = SimpleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  State _currentState = Initial();

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
          Init(gameField: var gameField, nation: var nation) => _processFromInitialOnInit(gameField, nation),
          _ => _currentState,
        },
      ReadyForInput() => switch (event) {
          Click(cell: var cell) => _processFromReadyForInputOnClick(cell),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          Click(cell: var cell) => _processFromWaitingForEndOfPathOnClick(startPathCell, cell),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          Click(cell: var cell) => _processFromPathIsShownOnClick(path, cell),
          _ => _currentState,
        },
    };

    _currentState = newState;
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
  }

  State _processFromInitialOnInit(GameFieldReadOnly gameField, Nation nation) {
    _gameField = gameField;
    _nation = nation;

    final cellsToAdd = _gameField.cells.where((c) => !c.isEmpty);
    _updateGameObjectsEvent.update(cellsToAdd.map((c) => UpdateObject(c)));

    return ReadyForInput();
  }

  State _processFromReadyForInputOnClick(GameFieldCell cell) {
    if (cell.nation != _nation) {
      return ReadyForInput();
    }

    final unit = cell.activeUnit;

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);
    _updateGameObjectsEvent.update([UpdateObject(cell)]);

    return WaitingForEndOfPath(cell);
  }

  State _processFromWaitingForEndOfPathOnClick(GameFieldCell startCell, GameFieldCell endCell) {
    final unit = startCell.activeUnit!;

    if (startCell == endCell) {
      // reset the unit active state
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateObject(startCell)]);
      return ReadyForInput();
    }

    // calculate a path
    Iterable<GameFieldCell> path = calculatePath(startCell: startCell, endCell: endCell, isLandUnit: unit.isLand);

    if (path.isEmpty) {
      // reset the unit active state
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateObject(startCell)]);
      return ReadyForInput();
    }

    final estimatedPath = estimatePath(path: path, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(estimatedPath);
  }

  State _processFromPathIsShownOnClick(Iterable<GameFieldCell> path, GameFieldCell cell) {
    final firstCell = path.first;

    final unit = firstCell.activeUnit!;

    /// Clear the old path
    void resetPath() {
      for (var pathCell in path) {
        pathCell.setPathItem(null);
      }
      _updateGameObjectsEvent.update(path.map((c) => UpdateObject(c)));
    }

    /// Clear the path and make the unit enabled
    State resetPathAndEnableUnit() {
      unit.setState(UnitState.enabled);
      resetPath();
      return ReadyForInput();
    }

    if (cell == path.first) {
      return resetPathAndEnableUnit();
    }

    // calculate a path
    Iterable<GameFieldCell> newPath = calculatePath(startCell: firstCell, endCell: cell, isLandUnit: unit.isLand);

    if (newPath.isEmpty) {
      return resetPathAndEnableUnit();
    }

    resetPath();

    // show the new path
    final estimatedPath = estimatePath(path: newPath, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(newPath);
  }

  Iterable<GameFieldCell> calculatePath({
    required GameFieldCell startCell,
    required GameFieldCell endCell,
    required bool isLandUnit,
  }) {
    final settings = isLandUnit ? LandFindPathSettings(startCell: startCell) : SeaFindPathSettings(startCell: startCell);

    final pathFinder = FindPath(_gameField, settings);
    return pathFinder.find(startCell, endCell);
  }

  Iterable<GameFieldCell> estimatePath({
    required Iterable<GameFieldCell> path,
    required bool isLandUnit,
  }) =>
      (isLandUnit ? LandPathCostCalculator(path) : SeaPathCostCalculator(path)).calculate();
}
