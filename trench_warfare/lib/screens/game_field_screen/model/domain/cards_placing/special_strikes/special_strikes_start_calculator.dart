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

class SpecialStrikesStartCalculator implements PlacingCalculator {
  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final SpecialStrikesCardsPlacingStrategy _strategy;

  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final MapMetadataRead _mapMetadata;

  late final MoneyStorageRead _nationMoney;

  late final GameFieldControlsCard<SpecialStrikeType> _card;

  SpecialStrikesStartCalculator({
    required SpecialStrikesCardsPlacingStrategy strategy,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead mapMetadata,
    required MoneyStorageRead nationMoney,
    required GameFieldControlsCard<SpecialStrikeType> card,
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
    final killedUnit = _strategy.updateGameField();

    // Calculate the money
    final productionCost = MoneySpecialStrikeCalculator.calculateCost(_card.type);

    // Calculate inactive cells
    final cellsImpossibleToBuild = SpecialStrikesBuildCalculator(_gameField, _myNation, _mapMetadata)
        .getAllCellsImpossibleToBuild(_card.type, _nationMoney.totalSum);

    _strategy.showUpdate(killedUnit);

    final canPlaceNext = _canPlaceNext(cellsImpossibleToBuild.length, productionCost);

    return CardPlacingInProgress(
        card: _card,
        productionCost: productionCost,
        newInactiveCells: canPlaceNext ? {for (var e in cellsImpossibleToBuild) e.id: e} : {},
        oldInactiveCells: _oldInactiveCells,
        canPlaceNext: canPlaceNext,
    );
  }

  bool _canPlaceNext(int totalCellsImpossibleToBuild, MoneyUnit productionCost) {
    final recalculatedNationMoney = _nationMoney.totalSum - productionCost;
    return totalCellsImpossibleToBuild < _gameField.cells.length && recalculatedNationMoney >= productionCost;
  }
}
