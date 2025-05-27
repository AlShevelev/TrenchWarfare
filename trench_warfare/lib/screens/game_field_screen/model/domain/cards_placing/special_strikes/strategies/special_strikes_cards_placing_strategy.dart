/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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

  @protected
  final UnitUpdateResultBridge? _unitUpdateResultBridge;

  @protected
  final Nation _myNation;

  SpecialStrikesCardsPlacingStrategy(
    SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    GameFieldCell cell,
    bool isAI,
    AnimationTime animationTime,
    UnitUpdateResultBridge? unitUpdateResultBridge,
    Nation myNation,
  )   : _updateGameObjectsEvent = updateGameObjectsEvent,
        _cell = cell,
        _isAI = isAI,
        _animationTime = animationTime,
        _unitUpdateResultBridge = unitUpdateResultBridge,
        _myNation = myNation;

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
