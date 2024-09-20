part of cards_placing;

class CardPlacingCalculator implements PlacingCalculator {
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final CardsPlacingStrategy _strategy;

  late final bool _isAI;

  CardPlacingCalculator({
    required CardsPlacingStrategy strategy,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required bool isAI,
  }) {
    _strategy = strategy;
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _oldInactiveCells = oldInactiveCells;
    _isAI = isAI;
  }

  @override
  State place() {
    _strategy.updateCell();

    final List<UpdateGameEvent> events = [];

    if (_isAI) {
      events.add(
        MoveCameraToCell(_strategy.cell),
      );
    }

    events.add(UpdateCell(
      _strategy.cell,
      updateBorderCells: [],
    ));

    events.add(
      Pause(_isAI ? AnimationConstants.pauseAfterBuildingAi : AnimationConstants.pauseAfterBuildingHuman),
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

  bool _canPlaceNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) =>
      totalCellsImpossibleToBuild < _strategy.gameField.cells.length &&
      _strategy.nationMoney.actual.currency >= productionCost.currency &&
      _strategy.nationMoney.actual.industryPoints >= productionCost.industryPoints;
}
