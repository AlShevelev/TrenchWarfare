library game_field_cell_info;

import 'package:flame/components.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/money_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';

part 'game_field_cell_info_brief.dart';
part 'game_field_cell_info_full.dart';
part 'game_field_cell_info_panel.dart';
part 'game_field_cell_info_game_object_painter.dart';