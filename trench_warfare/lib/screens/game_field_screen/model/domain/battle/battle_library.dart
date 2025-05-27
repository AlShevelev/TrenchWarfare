/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library battle;

import 'dart:math' as math;
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/core/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core/enums/unit_boost.dart';
import 'package:trench_warfare/core/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/game_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/pathfinding/pathfinding_library.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';
import 'package:trench_warfare/shared/utils/range.dart';

part 'battle_calculator.dart';
part 'dto/units_battle_result.dart';
part 'dto/unit_in_battle.dart';
part 'dto/battle_result.dart';
part 'battle_preparation_calculator.dart';
part 'battle_result_calculator.dart';