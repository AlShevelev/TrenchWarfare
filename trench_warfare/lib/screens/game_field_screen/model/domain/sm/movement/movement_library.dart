library movement;

import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/path_item_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/battle/battle_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';
import 'package:trench_warfare/shared/utils/math.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

part 'movement_calculator.dart';
part 'movement_constants.dart';
part 'movement_facade.dart';
part 'movement_with_battle_calculator.dart';
part 'movement_with_mine_field_calculator.dart';
part 'movement_without_obstacles_calculator.dart';