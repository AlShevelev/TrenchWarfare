/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library game_objects;

import 'dart:math' as math;
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core/enums/unit_state.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/game_constants.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:trench_warfare/shared/utils/range.dart';

part 'production_center.dart';
part 'terrain_modifier.dart';
part 'unit.dart';
part 'carrier.dart';

abstract class GameObject {}
