part of cards_placing;

class UnitCardPlacingCalculator implements PlacingCalculator {
  late final GameFieldControlsUnitCard _card;

  UnitType get _type => _card.type;

  late final GameFieldCell _cell;

  late final MoneyStorage _nationMoney;

  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  UnitCardPlacingCalculator({
    required GameFieldControlsUnitCard card,
    required GameFieldCell cell,
    required MoneyStorage nationMoney,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameFieldRead gameField,
    required Nation myNation,
    required SingleStream<GameFieldControlsState> controlsState,
    required Map<int, GameFieldCellRead> oldInactiveCells,
  }) {
    _card = card;
    _cell = cell;
    _nationMoney = nationMoney;
    _updateGameObjectsEvent = updateGameObjectsEvent;
    _gameField = gameField;
    _myNation = myNation;
    _controlsState = controlsState;
    _oldInactiveCells = oldInactiveCells;
  }

  @override
  State place() {
    final unit = _type == UnitType.carrier ? Carrier.create() : Unit.create(_type);

    // Update the cell
    _cell.addUnitAsActive(unit);

    _updateGameObjectsEvent.update([
      UpdateCell(
        _cell,
        updateBorderCells: [],
      )
    ]);

    // Update the money
    final productionCost = MoneyTroopsCalculator.calculateProductionCost(_type);
    _nationMoney.withdraw(productionCost);

    // Calculate inactive cells
    final buildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final cellsImpossibleToBuild = buildCalculator.getAllCellsImpossibleToBuild(_type);

    if (_canBuildNext(cellsImpossibleToBuild.length, productionCost)) {
      _controlsState.update(CardsPlacingControls(
        totalMoney: _nationMoney.actual,
        card: _card,
      ));

      final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

      _updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: cellsImpossibleToBuildMap,
          oldInactiveCells: _oldInactiveCells,
        )
      ]);

      return CardPlacing(_card, cellsImpossibleToBuildMap);
    } else {
      _controlsState.update(MainControls(
        money: _nationMoney.actual,
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
      totalCellsImpossibleToBuild < _gameField.cells.length &&
      _nationMoney.actual.currency >= productionCost.currency &&
      _nationMoney.actual.industryPoints >= productionCost.industryPoints;
}
