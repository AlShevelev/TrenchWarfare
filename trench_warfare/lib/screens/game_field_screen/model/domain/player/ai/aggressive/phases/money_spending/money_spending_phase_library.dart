/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library money_spending_phase_library;

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/special_strike_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/build/build_calculators_library.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/shared/aggressive_ai_shared_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/estimations/estimations.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/unit_update_result/unit_update_result_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/async_signal.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:trench_warfare/shared/utils/math.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

part 'money_spending_phase.dart';
part 'estimations/special_strike/air_bombardment_estimator.dart';
part 'estimations/special_strike/flame_troopers_estimator.dart';
part 'estimations/special_strike/flechettes_estimator.dart';
part 'estimations/special_strike/gas_attack_estimator.dart';
part 'estimations/special_strike/propaganda_estimator.dart';
part 'estimations/special_strike/special_strike_estimator.dart';
part 'estimations/terrain_modifier/anti_air_gun_estimator.dart';
part 'estimations/terrain_modifier/barbed_wire_estimator.dart';
part 'estimations/terrain_modifier/land_fort_estimator.dart';
part 'estimations/terrain_modifier/mine_field_estimator.dart';
part 'estimations/terrain_modifier/terrain_modifier_estimator.dart';
part 'estimations/terrain_modifier/trench_estimator.dart';
part 'estimations/unit_booster/attack_defence_estimator.dart';
part 'estimations/unit_booster/commander_estimator.dart';
part 'estimations/unit_booster/transport_estimator.dart';
part 'estimations/unit_booster/unit_booster_estimation_data.dart';
part 'estimations/air_field_estimator.dart';
part 'estimations/carriers_building_estimator.dart';
part 'estimations/production_center_estimator.dart';
part 'estimations/units_building_estimator.dart';
part 'processing/air_field_estimation_processor.dart';
part 'processing/carriers_estimation_processor.dart';
part 'processing/estimation_processor_base.dart';
part 'processing/production_center_estimation_processor.dart';
part 'processing/special_strike_estimation_processor.dart';
part 'processing/terrain_modifier_estimation_processor.dart';
part 'processing/unit_booster_estimation_processor.dart';
part 'processing/units_estimation_processor.dart';
