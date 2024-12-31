part of cards_placing;

class CardPlacingCalculator implements PlacingCalculator {
  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  final Map<int, GameFieldCellRead> _oldInactiveCells;

  final CardsPlacingStrategy _strategy;

  final bool _isAI;

  final AnimationTime _animationTime;

  CardPlacingCalculator({
    required CardsPlacingStrategy strategy,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required bool isAI,
    required AnimationTime animationTime,
  }) : _strategy = strategy,
    _updateGameObjectsEvent = updateGameObjectsEvent,
    _oldInactiveCells = oldInactiveCells,
    _isAI = isAI,
    _animationTime = animationTime;

  @override
  State place() {
    _strategy.updateCell();

    final List<UpdateGameEvent> events = [];

    if (_isAI) {
      events.add(
        MoveCameraToCell(_strategy.cell),
      );
    }

    _strategy.getSound()?.let((soundEvent) {
      events.add(soundEvent);
    });

    events.add(UpdateCell(
      _strategy.cell,
      updateBorderCells: [],
    ));

    events.add(
      Pause(_animationTime.pauseAfterBuilding),
    );

    events.add(AnimationCompleted());

    // Calculate the money
    final productionCost = _strategy.calculateProductionCost();

    // Calculate inactive cells
    final cellsImpossibleToBuild = _strategy.getAllCellsImpossibleToBuild();

    _updateGameObjectsEvent.update(events);

    final canPlaceNext = _canPlaceNext(cellsImpossibleToBuild.length, productionCost);

    return CardPlacingInProgress(
      card: _strategy.card,
      productionCost: productionCost,
      newInactiveCells: canPlaceNext ? {for (var e in cellsImpossibleToBuild) e.id: e} : {},
      oldInactiveCells: _oldInactiveCells,
      canPlaceNext: canPlaceNext,
    );
  }

  bool _canPlaceNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) {
    final recalculatedNationMoney = _strategy.nationMoney.totalSum - productionCost;
    return totalCellsImpossibleToBuild < _strategy.gameField.cells.length &&
        recalculatedNationMoney >= productionCost;
  }
}
