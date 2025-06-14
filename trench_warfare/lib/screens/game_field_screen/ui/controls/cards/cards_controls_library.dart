/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library card_controls;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/special_strike_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/build/build_calculators_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/card_photos.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';

part 'dto/card_dto.dart';
part 'dto/cards_screen_state.dart';
part 'dto/tab_dto.dart';
part 'ui/cards_bookmarks.dart';
part 'ui/cards_list.dart';
part 'cards_selection_screen.dart';
part 'dto/tab_code.dart';
part 'ui/cards/card_base.dart';
part 'ui/cards/build_restriction_panel.dart';
part 'ui/cards/cards_factory.dart';
part 'ui/cards/card_terrain_modifier.dart';
part 'ui/cards/card_unit.dart';
part 'ui/cards/card_unit_booster.dart';
part 'ui/cards/card_special_strikes.dart';
part 'ui/cards/card_production_center.dart';
part 'view_model/cards_selection_user_actions.dart';
part 'view_model/cards_selection_view_model.dart';