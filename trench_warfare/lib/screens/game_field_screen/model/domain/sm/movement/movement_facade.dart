library movement;

import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';

part 'movement_without_obstacles_calculator.dart';

class MovementFacade {
  late final Nation _nation;
  late final GameFieldReadOnly _gameField;
  late final SimpleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  MovementFacade({
    required Nation nation,
    required GameFieldReadOnly gameField,
    required SimpleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
  }) {
    _nation = nation;
    _gameField = gameField;
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  State startMovement(Iterable<GameFieldCell> path) {
    final calculator = MovementWithoutObstaclesCalculator(
      nation: _nation,
      gameField: _gameField,
      updateGameObjectsEvent: _updateGameObjectsEvent,
    );

    return calculator.startMovement(path);
  }
}
