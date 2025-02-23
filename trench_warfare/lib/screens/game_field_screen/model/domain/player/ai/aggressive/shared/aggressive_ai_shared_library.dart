library aggressive_ai_shared_library;

import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/movement/movement_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/shared/architecture/async_signal.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';

part 'carriers_target_calculator.dart';
part 'player_actions.dart';
part 'turn_phase.dart';