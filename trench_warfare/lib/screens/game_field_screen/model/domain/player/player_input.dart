part of player;

abstract interface class PlayerInput {
  bool get inputIsBlocked;

  void onClick(Vector2 position);

  void onLongClickStart(Vector2 position);

  void onLongClickEnd();

  void onAnimationComplete();

  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier});

  void onCardsButtonClick();

  void onEndOfTurnButtonClick();

  void onCardsSelectionCancelled();

  void onCardSelected(GameFieldControlsCard? card);

  void onCardsPlacingCancelled();

  void onCameraUpdated(double zoom, Vector2 position);

  // Starts a turn. Must not be called from the AI - it's called from the model
  void onStartTurn();
}