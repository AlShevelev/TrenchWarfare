library game_field_sm;

import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_controls_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';

import 'movement/movement_library.dart';

part 'event.dart';
part 'state.dart';
part 'transitions/game_object_transition_base.dart';
part 'transitions/from_initial_on_init_transition.dart';
part 'transitions/from_ready_for_input_on_click.dart';
part 'transitions/from_ready_for_input_on_long_click_start.dart';
part 'transitions/from_ready_for_input_on_long_click_end.dart';
part 'transitions/from_waiting_for_end_of_path_on_click.dart';
part 'transitions/from_path_is_shown_on_click.dart';

class GameFieldStateMachine implements Disposable {
  late final NationRecord _nationRecord;
  Nation get _nationCode => _nationRecord.code;

  late final GameFieldRead _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent = SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  State _currentState = Initial();

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
          Init(gameField: var gameField, nation: var nation) => _processFromInitialOnInit(gameField, nation),
          _ => _currentState,
        },
      ReadyForInput() => switch (event) {
          Click(cell: var cell) => FromReadyForInputOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nationCode,
            ).process(cell),
          LongClickStart(cell: var cell) => FromReadyForInputOnLongClickStart(
              _nationRecord,
              _controlsState,
            ).process(cell),
          LongClickEnd() => FromReadyForInputOnLongClickEnd(
              _nationRecord,
              _controlsState,
            ).process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          Click(cell: var cell) => FromWaitingForEndOfPathOnClick(
              _updateGameObjectsEvent,
              _gameField,
            ).process(startPathCell, cell),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          Click(cell: var cell) => FromPathIsShownOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nationCode,
            ).process(path, cell),
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
    _controlsState.close();
  }

  State _processFromInitialOnInit(GameFieldRead gameField, NationRecord nation) {
    _gameField = gameField;
    _nationRecord = nation;

    return FromInitialOnInitTransition(
      _updateGameObjectsEvent,
      _controlsState,
      _gameField,
      nation,
    ).process();
  }
}
