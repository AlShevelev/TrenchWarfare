library aggressive_ai_shared_library;

import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/shared/architecture/async_signal.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';

part 'carriers_target_calculator.dart';
part 'player_actions.dart';
part 'turn_phase.dart';