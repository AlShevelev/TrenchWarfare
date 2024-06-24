library aggressive_player_ai;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/player_ai.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';

part 'aggressive_player_ai.dart';
part 'phases/turn_phase.dart';
part 'phases/money_spending/money_spending_phase.dart';
part 'phases/money_spending/estimations/production_center_estimation.dart';
part 'phases/money_spending/estimations/units_estimation.dart';