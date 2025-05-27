/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

abstract interface class _CardsSelectionUserActions {
  void onTabSelected(_TabCode tabCode);

  void onCardSelected(int indexInTab);

  void onCardExpendedOrCollapsed(int indexInTab);
}