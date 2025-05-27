/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/player_ai.dart';

class PassivePlayerAi extends PlayerAi {
  PassivePlayerAi(super.player);

  @override
  void start() async {
    await Future.delayed(const Duration(milliseconds: 500));
    player.onEndOfTurnButtonClick();
  }
}