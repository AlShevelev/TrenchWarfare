part of cards_placing;

abstract interface class SpecialStrikesCardsPlacingStrategy {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  SpecialStrikesCardsPlacingStrategy(SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
  }

  void updateGameField();

  void showUpdate();
}