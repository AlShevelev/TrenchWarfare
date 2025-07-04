/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library cards_placing;

import 'package:flutter/foundation.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/enums/special_strike_type.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/animation_time/animation_time_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/build/build_calculators_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/calculators/money_calculators_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/unit_update_result/unit_update_result_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:tuple/tuple.dart';

part 'strategies/cards_placing_strategy.dart';
part 'strategies/production_center_cards_placing_strategy.dart';
part 'strategies/terrain_modifier_cards_placing_strategy.dart';
part 'strategies/unit_boost_cards_placing_strategy.dart';
part 'strategies/units_cards_placing_strategy.dart';
part 'placing_calculator.dart';
part 'card_placing_calculator.dart';
part 'special_strikes/special_strikes_start_calculator.dart';
part 'special_strikes/strategies/air_bombardment_card_placing_strategy.dart';
part 'special_strikes/strategies/flame_troopers_card_placing_strategy.dart';
part 'special_strikes/strategies/flechettes_card_placing_strategy.dart';
part 'special_strikes/strategies/gas_attack_card_placing_strategy.dart';
part 'special_strikes/strategies/propaganda_card_placing_strategy.dart';
part 'special_strikes/strategies/special_strikes_cards_placing_strategy.dart';
