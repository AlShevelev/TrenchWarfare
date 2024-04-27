part of game_field_sm;

sealed class Event {}

class OnInit implements Event {
  final GameFieldRead gameField;

  final Nation nation;

  final MoneyStorageRead money;

  final MapMetadataRead metadata;

  OnInit(this.gameField, this.nation, this.money, this.metadata);
}

class OnCellClick implements Event {
  final GameFieldCell cell;

  OnCellClick(this.cell);
}

class OnLongCellClickStart implements Event {
  final GameFieldCell cell;

  OnLongCellClickStart(this.cell);
}

class OnLongCellClickEnd implements Event { }

class OnMovementCompleted implements Event { }

class OnUnitsResorted implements Event {
  final int cellId;

  final Iterable<String> unitsId;

  OnUnitsResorted(this.cellId, this.unitsId);
}

class OnCardsButtonClick implements Event { }

class OnCancelled implements Event { }

class OnCardSelected implements Event {
  final GameFieldControlsCard card;

  OnCardSelected(this.card);
}

class OnCardPlaced implements Event {
  final GameFieldCellRead cell;

  OnCardPlaced(this.cell);
}