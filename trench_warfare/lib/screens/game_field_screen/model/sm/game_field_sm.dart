library game_field_sm;

import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';

part 'event.dart';
part 'state.dart';
part 'transitions/transition_base.dart';
part 'transitions/from_initial_on_init_transition.dart';
part 'transitions/from_ready_for_input_on_click.dart';
part 'transitions/from_waiting_for_end_of_path_on_click.dart';
part 'transitions/from_path_is_shown_on_click.dart';

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
          Click(cell: var cell) => FromReadyForInputOnClick(_updateGameObjectsEvent, _gameField, _nation).process(cell),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          Click(cell: var cell) =>
            FromWaitingForEndOfPathOnClick(_updateGameObjectsEvent, _gameField).process(startPathCell, cell),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          Click(cell: var cell) => FromPathIsShownOnClick(_updateGameObjectsEvent, _gameField, _nation).process(path, cell),
          _ => _currentState,
        },
      MovingInProgress() => switch (event) {
        MovementComplete() => ReadyForInput(),
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

    return FromInitialOnInitTransition(_updateGameObjectsEvent, _gameField).process();
  }
}
