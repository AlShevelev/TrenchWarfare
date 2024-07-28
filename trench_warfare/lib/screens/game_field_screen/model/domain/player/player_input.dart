part of player;

abstract interface class PlayerGameObjectCallback {
  void onAnimationComplete();
}

abstract interface class PlayerInput {
  void onClick(Vector2 position);

  void onLongClickStart(Vector2 position);

  void onLongClickEnd();

  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier});

  void onCardsButtonClick();

  void onEndOfTurnButtonClick();

  void onCardsSelectionCancelled();

  void onCardSelected(GameFieldControlsCard? card);

  void onCardsPlacingCancelled();

  void onCameraUpdated(double zoom, Vector2 position);

  /// Starts a turn. Must not be called from the AI - it's called from the model
  void onStartTurn();

  /// Confirms that a turn is started. Must not be called from the AI - it's called from the model
  void onStarTurnConfirmed();
}