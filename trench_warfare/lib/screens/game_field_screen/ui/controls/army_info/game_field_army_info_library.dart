library game_field_army_info;

import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/rendering.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_controls_state.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

part 'game_field_army_info_panel.dart';
part 'game_field_army_info_units_cache.dart';
part 'game_field_army_info_unit.dart';
part 'game_field_army_info_unit_painter.dart';
