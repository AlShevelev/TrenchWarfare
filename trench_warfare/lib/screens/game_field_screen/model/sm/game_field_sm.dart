library game_field_sm;

import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/find_path.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_find_path_settings.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/land_path_cost_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';

part 'event.dart';
part 'state.dart';

class GameFieldStateMachine implements Disposable {
  late final Nation _nation;

  late final GameFieldReadOnly _gameField;

  final SimpleStream<UpdateGameEvent> _updateGameObjectsEvent = SimpleStream<UpdateGameEvent>();
  Stream<UpdateGameEvent> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  State _currentState = Initial();

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
          Init(gameField: var gameField, nation: var nation) => _processFromInitialOnInit(gameField, nation),
          _ => _currentState,
        },
      PathIsShown(path: var path) => _currentState,
      ReadyForInput() => switch (event) {
          Click(cell: var cell) => _processFromReadyForInputOnClick(cell),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          Click(cell: var cell) => _processFromWaitingForEndOfPathOnClick(startPathCell, cell),
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
    _updateGameObjectsEvent.update(UpdateObjects(cellsToAdd));

    return ReadyForInput();
  }

  State _processFromReadyForInputOnClick(GameFieldCell cell) {
    if (cell.nation != _nation) {
      return ReadyForInput();
    }

    final unit = cell.activeUnit;

    if (unit == null) {
      return ReadyForInput();
    }

    // if unit can't move => return ReadyForInput();

    return WaitingForEndOfPath(cell);
  }

  State _processFromWaitingForEndOfPathOnClick(GameFieldCell startCell, GameFieldCell endCell) {
    final pathFinder = FindPath(_gameField, LandFindPathSettings(startCell: startCell));
    Iterable<GameFieldCell> path = pathFinder.find(startCell, endCell);

    // path is empty - show an error and mark unit as inactive

    final estimatedPath = LandPathCostCalculator(path).calculate();

    _updateGameObjectsEvent.update(UpdateObjects(estimatedPath));

    return PathIsShown(estimatedPath);
  }
}
