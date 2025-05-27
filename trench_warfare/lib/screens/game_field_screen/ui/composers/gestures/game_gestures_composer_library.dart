/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library game_gesture_composer;

import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/zoom_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';

part 'gestures_camera.dart';
part 'game_gestures_composer.dart';
part 'gesture_event.dart';