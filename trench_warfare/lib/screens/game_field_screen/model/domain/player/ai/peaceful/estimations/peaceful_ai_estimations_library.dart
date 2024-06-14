library estimations;

import 'dart:developer';
import 'dart:math' as math;

import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/estimations.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/build/build_calculators_library.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';

part 'estimation_records.dart';
part 'dangerous_estimation.dart';
part 'equals_estimation.dart';
part 'mine_fields_in_general_estimation.dart';
part 'production_center_in_general_estimation.dart';
part 'units_in_general_estimation.dart';