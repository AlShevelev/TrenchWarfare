library game_field;

import 'dart:math' as math;
import 'package:flame/extensions.dart';
import 'package:trench_warfare/core_entities/entities/hex_matrix/hex_matrix.dart';
import 'package:trench_warfare/core_entities/entities/hex_matrix/hex_matrix_item.dart';
import 'package:trench_warfare/shared/utils/range.dart';
import 'package:flame/components.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/shared/utils/math.dart';

part 'game_field.dart';
part 'game_field_cell.dart';
part 'path_item.dart';
part 'path_item_type.dart';
