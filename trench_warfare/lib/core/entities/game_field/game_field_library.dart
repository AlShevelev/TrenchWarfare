/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library game_field;

import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/entities/hex_matrix/hex_matrix_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';

part 'game_field.dart';
part 'game_field_cell.dart';
part 'path_item.dart';
part 'path_item_type.dart';
part 'unit_on_cell.dart';
