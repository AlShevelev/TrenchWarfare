/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';

abstract class PlayerAi {
  final PlayerInput player;

  PlayerAi(this.player);

  void start();
}