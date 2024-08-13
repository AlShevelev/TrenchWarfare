library units_moving_phase_library;

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/shared/aggressive_ai_shared_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/shared/architecture/async_signal.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/utils/math.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'actions/player_actions.dart';
part 'estimations/attack_estimation_processor.dart';
part 'estimations/carrier_interception_estimation_processor.dart';
part 'estimations/do_noting_estimation_processor.dart';
part 'estimations/move_to_enemy_pc_estimation_processor.dart';
part 'estimations/move_to_my_pc_estimation_processor.dart';
part 'estimations/resort_estimation_processor.dart';
part 'estimations/unit_estimation_processor_base.dart';

part 'units_iterator/stable_units_iterator.dart';
part 'units_iterator/unit_on_cell.dart';

part 'units_moving_phase.dart';