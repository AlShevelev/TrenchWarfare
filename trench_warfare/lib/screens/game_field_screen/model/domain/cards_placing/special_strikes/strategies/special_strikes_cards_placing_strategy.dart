part of cards_placing;

abstract interface class SpecialStrikesCardsPlacingStrategy {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldCell _cell;

  SpecialStrikesCardsPlacingStrategy(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldCell cell,
  ) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _cell = cell;
  }

  void updateGameField();

  void showUpdate();
}
