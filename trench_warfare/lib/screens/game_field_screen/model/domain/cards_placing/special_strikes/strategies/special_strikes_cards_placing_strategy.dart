part of cards_placing;

abstract interface class SpecialStrikesCardsPlacingStrategy {
  @protected
  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  final GameFieldCell _cell;

  @protected
  final bool _isAI;

  @protected
  final AnimationTime _animationTime;

  SpecialStrikesCardsPlacingStrategy(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldCell cell,
    bool isAI,
    AnimationTime animationTime,
  )   : _updateGameObjectsEvent = updateGameObjectsEvent,
        _cell = cell,
        _isAI = isAI,
        _animationTime = animationTime;

  /// [return] killed units (or hit by propaganda)
  @protected
  Unit? updateGameField();

  /// [killedUnit] (or hit by propaganda)
  @protected
  void showUpdate(Unit? killedUnit) {
    final List<UpdateGameEvent> events = [];

    if (_isAI) {
      events.add(
        MoveCameraToCell(_cell),
      );
    }

    events.addAll(_getUpdateEvents(killedUnit));

    _updateGameObjectsEvent.update(events);
  }

  /// [killedUnit] (or hit by propaganda)
  @protected
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit);
}
