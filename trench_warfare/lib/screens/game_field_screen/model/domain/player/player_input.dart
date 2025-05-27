/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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

  void onMenuButtonClick();

  void onEndOfTurnButtonClick();

  void onCancelled();

  void onCardSelected(GameFieldControlsCard? card);

  void onCardsPlacingCancelled();

  void onCameraUpdated(double zoom, Vector2 position);

  /// Starts a turn. Must not be called from the AI - it's called from the model
  void onStartTurn();

  /// Confirms that a turn is started. Must not be called from the AI - it's called from the model
  /// [fireCallbackForAi] - we need to fire continuation callback for AI player
  void onPopupDialogClosed({required bool fireCallbackForAi});

  void onPhoneBackAction();

  void onMenuQuitButtonClick();

  void onMenuObjectivesButtonClick();

  void onMenuSaveButtonClick();

  void onMenuSettingsButtonClick();

  void onSaveSlotSelected(GameSlot slot);

  void onSettingsClosed(SettingsResult result);

  void onUserConfirmed();

  void onUserDeclined();

  void onDisbandUnitButtonClick();
}