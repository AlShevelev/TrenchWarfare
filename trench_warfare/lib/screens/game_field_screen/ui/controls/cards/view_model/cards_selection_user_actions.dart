part of card_controls;

abstract interface class _CardsSelectionUserActions {
  void onTabSelected(_TabCode tabCode);

  void onCardSelected(int indexInTab);

  void onCardExpendedOrCollapsed(int indexInTab);
}