/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';

abstract interface class MapSelectionUserActions {
  void onTabSelected(TabCode tabCode);

  void onCardSelected(String cardId);

  void onCardExpanded(String cardId);

  void onOpponentSelected(String cardId, Nation opponent);
}