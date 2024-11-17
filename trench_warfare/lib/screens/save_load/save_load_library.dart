library save_load_screen;

import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
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