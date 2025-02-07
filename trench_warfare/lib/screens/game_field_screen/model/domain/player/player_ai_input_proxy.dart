part of player;

class PlayerAiInputProxy extends PlayerInputProxy implements PlayerMoney {
  final PlayerCore _playerCore;

  @override
  MoneyStorageRead get money => _playerCore.money;

  @override
  Nation get nation => _playerCore.nation;

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
  void onCancelled() {
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

  @override
  void onMenuQuitButtonClick() {
    // do nothing
  }

  @override
  void onMenuObjectivesButtonClick() {
    // do nothing
  }

  @override
  void onMenuSaveButtonClick() {
    // do nothing
  }

  @override
  void onMenuSettingsButtonClick() {
    // do nothing
  }

  @override
  void onSaveSlotSelected(GameSlot slot) {
    // do nothing
  }

  @override
  void onSettingsClosed(SettingsResult result) {
    // do nothing
  }

  @override
  void onUserConfirmed() {
    // do nothing
  }

  @override
  void onUserDeclined() {
    // do nothing
  }

  @override
  void onDisbandUnitButtonClick() {
    // do nothing
  }
}
