library map_selection_ui;

import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';
import 'package:trench_warfare/shared/ui_kit/helpers.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:trench_warfare/screens/new_game/view_model/map_selection_user_actions.dart';
import 'package:trench_warfare/screens/new_game/view_model/map_selection_view_model.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';
import 'package:trench_warfare/shared/ui_kit/stroked_text.dart';

part 'card_banners/card_banners.dart';
part 'card_banners/card_banners_neutrals.dart';
part 'card_banners/card_banners_opponent.dart';
part 'card_banners/card_banners_opponents.dart';
part 'helpers.dart';
part 'map_selection.dart';
part 'bookmarks.dart';
part 'card.dart';
part 'maps_list.dart';
