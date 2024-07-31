library movement;

import 'package:flutter/foundation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/battle/battle_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'movement_calculator.dart';
part 'movement_constants.dart';
part 'movement_facade.dart';
part 'movement_with_battle_calculator.dart';
part 'movement_with_battle_next_unreachable_cell_calculator.dart';
part 'movement_with_mine_field_calculator.dart';
part 'movement_without_obstacles_calculator.dart';