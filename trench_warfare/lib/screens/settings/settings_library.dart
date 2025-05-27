/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library settings;

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/settings_constants.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_facade.dart';
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