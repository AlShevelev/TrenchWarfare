part of player;

abstract interface class PlayerInput {
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
}