library player_ai;

import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/peaceful/estimations/peaceful_ai_estimations_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

part 'player_ai.dart';
part 'aggressive/aggressive_player_ai.dart';
part 'passive/passive_player_ai.dart';
part 'peaceful/peaceful_player_ai.dart';