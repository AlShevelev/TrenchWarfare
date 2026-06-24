/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library game_field_components;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_state.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';
import 'package:trench_warfare/shared/utils/math.dart';
import 'package:trench_warfare/shared/utils/range.dart';
import 'package:tuple/tuple.dart';

part 'component_constants.dart';
part 'animation_frame_to_frame_component.dart';
part 'game_cell_border.dart';
part 'game_cell_inactive.dart';
part 'game_object_component_base.dart';
part 'game_object_debug.dart';
part 'game_object_cell.dart';
part 'game_object_untied_unit.dart';
part 'snapshot_component.dart';