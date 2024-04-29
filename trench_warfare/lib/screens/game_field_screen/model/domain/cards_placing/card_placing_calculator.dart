part of cards_placing;

class CardPlacingCalculator implements PlacingCalculator {
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final CardsPlacingStrategy _strategy;

  CardPlacingCalculator({
    required CardsPlacingStrategy strategy,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required SingleStream<GameFieldControlsState> controlsState,
    required Map<int, GameFieldCellRead> oldInactiveCells,
  }) {
    _strategy = strategy;
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _controlsState = controlsState;
    _oldInactiveCells = oldInactiveCells;
  }

  @override
  State place() {
    _strategy.updateCell();

    _updateGameObjectsEvent.update([
      UpdateCell(
        _strategy.cell,
        updateBorderCells: [],
      )
    ]);

    // Update the money
    final productionCost = _strategy.calculateProductionCost();
    _strategy.nationMoney.withdraw(productionCost);

    // Calculate inactive cells
    final cellsImpossibleToBuild = _strategy.getAllCellsImpossibleToBuild();

    if (_canBuildNext(cellsImpossibleToBuild.length, productionCost)) {
      _controlsState.update(CardsPlacingControls(
        totalMoney: _strategy.nationMoney.actual,
        card: _strategy.card,
      ));

      final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

      _updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: cellsImpossibleToBuildMap,
          oldInactiveCells: _oldInactiveCells,
        )
      ]);

      return CardPlacing(_strategy.card, cellsImpossibleToBuildMap);
    } else {
      _controlsState.update(MainControls(
        money: _strategy.nationMoney.actual,
        cellInfo: null,
        armyInfo: null,
      ));

      _updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: {},
          oldInactiveCells: _oldInactiveCells,
        )
      ]);

      return ReadyForInput();
    }
  }

  bool _canBuildNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) =>
      totalCellsImpossibleToBuild < _strategy.gameField.cells.length &&
      _strategy.nationMoney.actual.currency >= productionCost.currency &&
      _strategy.nationMoney.actual.industryPoints >= productionCost.industryPoints;
}
