part of game_field_sm;

sealed class Event {}

class Init implements Event {
  final GameFieldRead gameField;

  final Nation nation;

  final MoneyStorageRead money;

  Init(this.gameField, this.nation, this.money);
}

class Click implements Event {
  final GameFieldCell cell;

  Click(this.cell);
}

class LongClickStart implements Event {
  final GameFieldCell cell;

  LongClickStart(this.cell);
}

class LongClickEnd implements Event { }

class MovementComplete implements Event {}

class ResortUnits implements Event {
  final String cellId;

  final Iterable<String> unitsId;

  ResortUnits(this.cellId, this.unitsId);
}

class CardsButtonClick implements Event { }

class CardsClose implements Event { }
