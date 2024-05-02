part of cards_placing;

class SpecialStrikesStartCalculator implements PlacingCalculator {
  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final SpecialStrikesCardsPlacingStrategy _strategy;

  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final MapMetadataRead _mapMetadata;

  late final MoneyStorageRead _nationMoney;

  late final GameFieldControlsSpecialStrikesCard _card;

  SpecialStrikesStartCalculator({
    required SpecialStrikesCardsPlacingStrategy strategy,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead mapMetadata,
    required MoneyStorageRead nationMoney,
    required GameFieldControlsSpecialStrikesCard card,
  }) {
    _strategy = strategy;
    _oldInactiveCells = oldInactiveCells;
    _gameField = gameField;
    _myNation = myNation;
    _mapMetadata = mapMetadata;
    _nationMoney = nationMoney;
    _card = card;
  }

  @override
  State place() {
    _strategy.updateGameField();

    // calculate the money
    final productionCost = MoneySpecialStrikeCalculator.calculateCost(_card.type);

    // Calculate inactive cells
    final cellsImpossibleToBuild = SpecialStrikesBuildCalculator(_gameField, _myNation, _mapMetadata)
        .getAllCellsImpossibleToBuild(_card.type, _nationMoney.actual);

    final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

    _strategy.showUpdate();

    if (_canPlaceNext(cellsImpossibleToBuild.length, productionCost)) {
      return CardPlacingSpecialStrikeInProgress(
          card: _card,
          productionCost: productionCost,
          newInactiveCells: cellsImpossibleToBuildMap,
          oldInactiveCells: _oldInactiveCells,
          canPlaceNext: true);
    } else {
      return CardPlacingSpecialStrikeInProgress(
          card: _card,
          productionCost: productionCost,
          newInactiveCells: {},
          oldInactiveCells: _oldInactiveCells,
          canPlaceNext: false);
    }
  }

  bool _canPlaceNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) {
    final recalculatedNationMoney = _nationMoney.actual - productionCost;
    return totalCellsImpossibleToBuild < _gameField.cells.length && recalculatedNationMoney >= productionCost;
  }
}
