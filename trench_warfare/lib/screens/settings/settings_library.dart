library settings;

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/settings_constants.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';
import 'package:trench_warfare/shared/ui_kit/stroked_text.dart';

part 'model/settings_result.dart';
part 'model/state_dto.dart';
part 'settings_screen.dart';
part 'view_model/settings_user_actions.dart';
part 'view_model/settings_view_model.dart';
part 'ui/bookmark.dart';
part 'ui/settings.dart';
part 'ui/settings_slider.dart';