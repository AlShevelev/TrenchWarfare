library game_field_cell_info;

import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cell_info/game_field_cell_info_game_object_painter.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_controls_state.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';

part 'game_field_cell_info_brief.dart';
part 'game_field_cell_info_full.dart';
part 'game_field_cell_info_panel.dart';