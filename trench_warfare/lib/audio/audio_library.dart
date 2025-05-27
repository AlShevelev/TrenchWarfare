/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

library audio;

import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/settings_constants.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_facade.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

part 'audio_controller.dart';
part 'audio_ext.dart';
part 'music_player.dart';
part 'sound_strategy.dart';
part 'sound_type.dart';
part 'sounds_player.dart';