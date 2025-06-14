/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library game_builders;

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_state.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/database/database.dart';
import 'package:trench_warfare/database/entities/save_game_field_cell_db_entity.dart';
import 'package:trench_warfare/database/entities/save_nation_db_entity.dart';
import 'package:trench_warfare/database/entities/save_slot_db_entity.dart';
import 'package:trench_warfare/database/entities/save_troop_transfer_db_entity.dart';
import 'package:trench_warfare/database/entities/save_unit_db_entity.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/phases/carriers/carriers_phase_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/shared/data/map_decoder.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_facade.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';
import 'package:tuple/tuple.dart';

part 'game_build_result.dart';
part 'game_builder.dart';
part 'loaded_game_builder.dart';
part 'new_game_builder.dart';
part 'troop_transfer_read_for_saving_impl.dart';