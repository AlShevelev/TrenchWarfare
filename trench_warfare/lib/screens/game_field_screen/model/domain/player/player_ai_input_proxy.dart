part of player;

class PlayerAiInputProxy extends PlayerInputProxy {
  final PlayerCore _playerCore;

  PlayerAiInputProxy({required PlayerCore playerCore}) : _playerCore = playerCore;

  @override
  void onAnimationComplete() => _playerCore.onAnimationComplete();

  @override
  void onCameraUpdated(double zoom, Vector2 position) {
    // do nothing
  }

  @override
  void onCardSelected(GameFieldControlsCard? card) {
    // do nothing
  }

  @override
  void onCardsButtonClick() {
    // do nothing
  }

  @override
  void onCardsPlacingCancelled() {
    // do nothing
  }

  @override
  void onCardsSelectionCancelled() {
    // do nothing
  }

  @override
  void onClick(Vector2 position) {
    // do nothing
  }

  @override
  void onEndOfTurnButtonClick() {
    // do nothing
  }

  @override
  void onLongClickEnd() {
    // do nothing
  }

  @override
  void onLongClickStart(Vector2 position) {
    // do nothing
  }

  @override
  void onPopupDialogClosed() => _playerCore.onPopupDialogClosed();

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    // do nothing
  }

  @override
  void onStartTurn() => _playerCore.onStartTurn();

  @override
  void onMenuButtonClick() {
    // do nothing
  }

  @override
  void onPhoneBackAction() {
    // do nothing
  }
}
