library game_field_army_info;

import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/rendering.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

part 'game_field_army_info_panel.dart';
part 'game_field_army_info_units_cache.dart';
part 'game_field_army_info_unit.dart';
part 'game_field_army_info_unit_painter.dart';
