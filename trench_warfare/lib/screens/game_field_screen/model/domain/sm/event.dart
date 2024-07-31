part of game_field_sm;

sealed class Event {}

class OnCellClick implements Event {
  final GameFieldCell cell;

  OnCellClick(this.cell);
}

class OnLongCellClickStart implements Event {
  final GameFieldCell cell;

  OnLongCellClickStart(this.cell);
}

class OnLongCellClickEnd implements Event { }

class OnAnimationCompleted implements Event { }

class OnUnitsResorted implements Event {
  final int cellId;

  final Iterable<String> unitsId;

  final bool isCarrier;

  OnUnitsResorted(this.cellId, this.unitsId, {required this.isCarrier});
}

class OnCardsButtonClick implements Event { }

class OnEndOfTurnButtonClick implements Event { }

class OnCancelled implements Event { }

class OnCardSelected implements Event {
  final GameFieldControlsCard card;

  OnCardSelected(this.card);
}

class OnCardPlaced implements Event {
  final GameFieldCellRead cell;

  OnCardPlaced(this.cell);
}

class OnStarTurn implements Event {}

class OnPopupDialogClosed implements Event {}