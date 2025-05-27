/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library save_load_screen;

import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/database/database.dart';
import 'package:trench_warfare/database/entities/save_slot_db_entity.dart';
import 'package:trench_warfare/shared/data/map_decoder.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/shared/ui_kit/helpers.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';
import 'package:trench_warfare/shared/ui_kit/stroked_text.dart';

part 'model/dto/slot_dto.dart';
part 'model/dto/state_dto.dart';
part 'view_model/save_load_user_actions.dart';
part 'view_model/save_load_view_model.dart';
part 'ui/bookmarks.dart';
part 'ui/data_card.dart';
part 'ui/empty_card.dart';
part 'ui/opponent.dart';
part 'ui/opponents.dart';
part 'ui/slot_selection.dart';
part 'save_load_screen.dart';