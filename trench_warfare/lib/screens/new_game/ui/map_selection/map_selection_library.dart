library map_selection_ui;

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/navigation/routes.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core_entities/localization/app_locale.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:trench_warfare/screens/new_game/view_model/map_selection_view_model.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';
import 'package:trench_warfare/shared/ui_kit/stroked_text.dart';

part 'map_selection.dart';
part 'map_selection_bookmarks.dart';