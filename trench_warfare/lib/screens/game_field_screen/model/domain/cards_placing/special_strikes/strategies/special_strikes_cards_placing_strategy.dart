part of cards_placing;

abstract interface class SpecialStrikesCardsPlacingStrategy {
  @protected
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  late final GameFieldCell _cell;

  @protected
  late final bool _isAI;

  SpecialStrikesCardsPlacingStrategy(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldCell cell,
    bool isAI,
  ) {
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _cell = cell;
    _isAI = isAI;
  }

  @protected
  void updateGameField();

  @protected
  void showUpdate() {
    final List<UpdateGameEvent> events = [];

    if (_isAI) {
      events.add(
        MoveCameraToCell(_cell),
      );
    }

    events.addAll(_getUpdateEvents());

    _updateGameObjectsEvent.update(events);
  }

  @protected
  Iterable<UpdateGameEvent> _getUpdateEvents();
}
