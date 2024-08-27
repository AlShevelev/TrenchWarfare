library carriers_phase_library;

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/core_entities/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/phases/units_moving/units_moving_phase_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/shared/aggressive_ai_shared_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'carrier_troop_transfers_storage.dart';
part 'carriers_phase.dart';
part 'transfers/troop_transfer.dart';
part 'transfers/dto/landing_point.dart';
part 'transfers/troop_transfer_state.dart';
part 'transfers/transitions/calculators/gathering_point_calculator.dart';
part 'transfers/transitions/gathering_transition.dart';
part 'transfers/transitions/init_transition.dart';
part 'transfers/transitions/loading_to_carrier_transition.dart';
part 'transfers/transitions/landing_transition.dart';
part 'transfers/transitions/movement_after_lading_transition.dart';
part 'transfers/transitions/transporting_transition.dart';
part 'transfers/transitions/transition.dart';
