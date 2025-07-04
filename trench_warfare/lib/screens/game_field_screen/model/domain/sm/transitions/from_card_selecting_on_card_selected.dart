/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

class FromCardSelectingOnCardsSelected {
  final GameFieldStateMachineContext _context;

  FromCardSelectingOnCardsSelected(this._context);

  State process(GameFieldControlsCard card) {
    _context.controlsState.update(CardsPlacingControls(
      totalMoney: _context.money.totalSum,
      card: card,
      nation: _context.myNation,
    ));

    final cellsImpossibleToBuild = switch (card) {
      GameFieldControlsUnitCard() ||
      GameFieldControlsUnitCardBrief() =>
        UnitBuildCalculator(_context.gameField, _context.myNation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.totalSum,
        ),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        ProductionCentersBuildCalculator(_context.gameField, _context.myNation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.totalSum),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        TerrainModifierBuildCalculator(_context.gameField, _context.myNation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.totalSum),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        UnitBoosterBuildCalculator(_context.gameField, _context.myNation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.totalSum,
        ),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesBuildCalculator(
          _context.gameField,
          _context.myNation,
          _context.mapMetadata,
        ).getAllCellsImpossibleToBuild(card.type, _context.money.totalSum),
      _ => throw UnsupportedError(''),
    };

    final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: cellsImpossibleToBuildMap,
          oldInactiveCells: {},
        )
      ]);
    }

    return CardPlacing(card, cellsImpossibleToBuildMap);
  }
}
