part of cards_placing;

class TerrainModifierCardPlacingCalculator implements PlacingCalculator {
  late final GameFieldControlsTerrainModifiersCard _card;

  TerrainModifierType get _type => _card.type;

  late final GameFieldCell _cell;

  late final MoneyStorage _nationMoney;

  late final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  TerrainModifierCardPlacingCalculator({
    required GameFieldControlsTerrainModifiersCard card,
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
    final terrainModifier = TerrainModifier(type: _type);

    // Update the cell
    _cell.setTerrainModifier(terrainModifier);

    _updateGameObjectsEvent.update([
      UpdateCell(
        _cell,
        updateBorderCells: [],
      )
    ]);

    // Update the money
    final productionCost = MoneyTerrainModifierCalculator.calculateBuildCost(_cell.terrain, _type)!;
    _nationMoney.withdraw(productionCost);

    // Calculate inactive cells
    final buildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final cellsImpossibleToBuild = buildCalculator.getAllCellsImpossibleToBuild(_type, _nationMoney.actual);

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
