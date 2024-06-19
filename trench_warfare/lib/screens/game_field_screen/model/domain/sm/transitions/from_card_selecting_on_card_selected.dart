part of game_field_sm;

class FromCardSelectingOnCardsSelected extends GameObjectTransitionBase {
  FromCardSelectingOnCardsSelected(super.context);

  State process(GameFieldControlsCard card) {
    _context.controlsState.update(CardsPlacingControls(
      totalMoney: _context.money.actual,
      card: card,
    ));

    final cellsImpossibleToBuild = switch (card) {
      GameFieldControlsUnitCard() ||
      GameFieldControlsUnitCardBrief() =>
        UnitBuildCalculator(_context.gameField, _context.nation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.actual,
        ),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        ProductionCentersBuildCalculator(_context.gameField, _context.nation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.actual),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        TerrainModifierBuildCalculator(_context.gameField, _context.nation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.actual),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        UnitBoosterBuildCalculator(_context.gameField, _context.nation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.actual,
        ),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesBuildCalculator(
          _context.gameField,
          _context.nation,
          _context.mapMetadata,
        ).getAllCellsImpossibleToBuild(card.type, _context.money.actual),
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
