part of game_field_sm;

sealed class Event {}

class OnCellClick implements Event {
  final GameFieldCell cell;

  OnCellClick(this.cell);

  @override
  String toString() => 'ON_CELL_CLICK: {cell: $cell}';
}

class OnLongCellClickStart implements Event {
  final GameFieldCell cell;

  OnLongCellClickStart(this.cell);

  @override
  String toString() => 'ON_LONG_CELL_CLICK_START: {cell: $cell}';
}

class OnLongCellClickEnd implements Event {
  @override
  String toString() => 'ON_LONG_CELL_CLICK_END';
}

class OnAnimationCompleted implements Event {
  @override
  String toString() => 'ON_ANIMATION_COMPLETED';
}

class OnUnitsResorted implements Event {
  final int cellId;

  final Iterable<String> unitsId;

  final bool isCarrier;

  OnUnitsResorted(this.cellId, this.unitsId, {required this.isCarrier});

  @override
  String toString() => 'ON_UNITS_RESORTED: {cellId: $cellId: isCarrier: $isCarrier; unitsId: [${unitsId.join('|')}]}';
}

class OnCardsButtonClick implements Event {
  @override
  String toString() => 'ON_CARDS_BUTTON_CLICK';
}

class OnEndOfTurnButtonClick implements Event {
  @override
  String toString() => 'ON_END_OF_TURN_BUTTON_CLICK';
}

class OnCancelled implements Event {
  @override
  String toString() => 'ON_CANCELLED';
}

class OnCardSelected implements Event {
  final GameFieldControlsCard card;

  OnCardSelected(this.card);

  @override
  String toString() => 'ON_CARD_SELECTED: {card: $card}';
}

class OnCardPlaced implements Event {
  final GameFieldCellRead cell;

  OnCardPlaced(this.cell);

  @override
  String toString() => 'ON_CARD_PLACED: {cell: $cell}';
}

class OnStarTurn implements Event {
  @override
  String toString() => 'ON_STAR_TURN';
}

class OnPopupDialogClosed implements Event {
  @override
  String toString() => 'ON_POPUP_DIALOG_CLOSED';
}

class OnMenuButtonClick implements Event {
  @override
  String toString() => 'ON_MENU_BUTTON_CLICK';
}

class OnMenuQuitButtonClick implements Event {
  @override
  String toString() => 'ON_MENU_QUIT_BUTTON_CLICK';
}

class OnMenuObjectivesButtonClick implements Event {
  @override
  String toString() => 'ON_MENU_OBJECTIVES_BUTTON_CLICK';
}

class OnPhoneBackAction implements Event {
  @override
  String toString() => 'ON_PHONE_BACK_ACTION';
}

class OnMenuSaveButtonClick implements Event {
  @override
  String toString() => 'ON_MENU_SAVE_BUTTON_CLICK';
}

class OnMenuSettingsButtonClick implements Event {
  @override
  String toString() => 'ON_MENU_SETTINGS_BUTTON_CLICK';
}

class OnSaveSlotSelected implements Event {
  final GameSlot slot;

  OnSaveSlotSelected({required this.slot});

  @override
  String toString() => 'ON_SAVE_SLOT_SELECTED: {slot: $slot}';
}

class OnSettingsClosed implements Event {
  final SettingsResult result;

  OnSettingsClosed({required this.result});

  @override
  String toString() => 'ON_SETTINGS_CLOSED: {music: ${result.music}; sounds: ${result.sounds}; '
      'myUnitsSpeed: ${result.humanUnitsSpeed}; enemyUnitsSpeed: ${result.aiUnitsSpeed};}';
}

class OnTurnCompletedConfirmed implements Event {
  OnTurnCompletedConfirmed();

  @override
  String toString() => 'ON_TURN_COMPLETED_CONFIRMED';
}

class OnTurnCompletedDeclined implements Event {
  OnTurnCompletedDeclined();

  @override
  String toString() => 'ON_TURN_COMPLETED_DECLINED';
}
