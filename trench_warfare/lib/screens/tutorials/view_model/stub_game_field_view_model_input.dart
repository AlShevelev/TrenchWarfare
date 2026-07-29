import 'package:flame/components.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';
import 'package:trench_warfare/screens/settings/settings_library.dart';

class StubGameFieldViewModelInput implements GameFieldViewModelInput, PlayerInput, PlayerGameObjectCallback {
  @override
  PlayerGameObjectCallback get gameObjectCallback => this;

  @override
  PlayerInput get input => this;

  @override
  bool get isHumanPlayer => true;

  @override
  void onCameraUpdated(double zoom, Vector2 position) {
    // do nothing here
  }

  @override
  void onCancelled() {
    // do nothing here
  }

  @override
  void onCardSelected(GameFieldControlsCard? card) {
    // do nothing here
  }

  @override
  void onCardsButtonClick() {
    // do nothing here
  }

  @override
  void onCardsPlacingCancelled() {
    // do nothing here
  }

  @override
  void onClick(Vector2 position) {
    // do nothing here
  }

  @override
  void onDisbandUnitButtonClick() {
    // do nothing here
  }

  @override
  void onEndOfTurnButtonClick() {
    // do nothing here
  }

  @override
  void onLongClickEnd() {
    // do nothing here
  }

  @override
  void onLongClickStart(Vector2 position) {
    // do nothing here
  }

  @override
  void onMenuButtonClick() {
    // do nothing here
  }

  @override
  void onMenuObjectivesButtonClick() {
    // do nothing here
  }

  @override
  void onMenuQuitButtonClick() {
    // do nothing here
  }

  @override
  void onMenuSaveButtonClick() {
    // do nothing here
  }

  @override
  void onMenuSettingsButtonClick() {
    // do nothing here
  }

  @override
  void onPhoneBackAction() {
    // do nothing here
  }

  @override
  void onPopupDialogClosed({required bool fireCallbackForAi}) {
    // do nothing here
  }

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    // do nothing here
  }

  @override
  void onSaveSlotSelected(GameSlot slot) {
    // do nothing here
  }

  @override
  void onSettingsClosed(SettingsResult result) {
    // do nothing here
  }

  @override
  void onStartTurn() {
    // do nothing here
  }

  @override
  void onUserConfirmed() {
    // do nothing here
  }

  @override
  void onUserDeclined() {
    // do nothing here
  }

  @override
  void onAnimationComplete() {
    // do nothing here
  }

  @override
  void onNextEnabledUnitButtonClick() {
    // do nothing here
  }
}
