part of game_field_sm;

sealed class Event {}

class Init implements Event {
  final GameFieldReadOnly gameField;
  final Nation nation;

  Init(this.gameField, this.nation);
}

class Click implements Event {
  final GameFieldCell cell;

  Click(this.cell);
}