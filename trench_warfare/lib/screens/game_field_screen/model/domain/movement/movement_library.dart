/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library movement;

import 'package:flutter/foundation.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/animation_time/animation_time_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/unit_update_result/unit_update_result_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/battle/battle_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'movement_calculator.dart';
part 'movement_facade.dart';
part 'movement_with_battle_calculator.dart';
part 'movement_with_battle_next_unreachable_cell_calculator.dart';
part 'movement_with_mine_field_calculator.dart';
part 'movement_without_obstacles_calculator.dart';
part 'show_damage_calculator.dart';