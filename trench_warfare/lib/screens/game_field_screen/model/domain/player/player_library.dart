/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library player;

import 'package:flame/components.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/animation_time/animation_time_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/day/day_storage.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/unit_update_result/unit_update_result_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_pause.dart';
import 'package:trench_warfare/screens/settings/settings_library.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';

part 'player_ai_input_proxy.dart';
part 'player_input.dart';
part 'player_input_proxy.dart';
part 'player_core.dart';
part 'player_money.dart';