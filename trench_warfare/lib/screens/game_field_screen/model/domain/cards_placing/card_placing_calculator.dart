part of cards_placing;

class CardPlacingCalculator implements PlacingCalculator {
  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final CardsPlacingStrategy _strategy;

  late final bool _isAI;

  CardPlacingCalculator({
    required CardsPlacingStrategy strategy,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required SimpleStream<GameFieldControlsState> controlsState,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required bool isAI,
  }) {
    _strategy = strategy;
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _controlsState = controlsState;
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
    events.add(
        UpdateCell(
          _strategy.cell,
          updateBorderCells: [],
        )
    );
    _updateGameObjectsEvent.update(events);

    // Update the money
    final productionCost = _strategy.calculateProductionCost();
    _strategy.nationMoney.withdraw(productionCost);

    // Calculate inactive cells
    final cellsImpossibleToBuild = _strategy.getAllCellsImpossibleToBuild();

    if (_canPlaceNext(cellsImpossibleToBuild.length, productionCost)) {
      _controlsState.update(CardsPlacingControls(
        totalMoney: _strategy.nationMoney.actual,
        card: _strategy.card,
      ));

      final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

      if (!_isAI) {
        _updateGameObjectsEvent.update([
          UpdateCellInactivity(
            newInactiveCells: cellsImpossibleToBuildMap,
            oldInactiveCells: _oldInactiveCells,
          )
        ]);
      }

      return CardPlacing(_strategy.card, cellsImpossibleToBuildMap);
    } else {
      _controlsState.update(MainControls(
        money: _strategy.nationMoney.actual,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ));

      if (!_isAI) {
        _updateGameObjectsEvent.update([
          UpdateCellInactivity(
            newInactiveCells: {},
            oldInactiveCells: _oldInactiveCells,
          )
        ]);
      }

      return ReadyForInput();
    }
  }

  bool _canPlaceNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) =>
      totalCellsImpossibleToBuild < _strategy.gameField.cells.length &&
      _strategy.nationMoney.actual.currency >= productionCost.currency &&
      _strategy.nationMoney.actual.industryPoints >= productionCost.industryPoints;
}
