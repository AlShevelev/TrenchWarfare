part of game_field_sm;

class FromCardSelectingOnCardsSelected {
  final GameFieldStateMachineContext _context;

  FromCardSelectingOnCardsSelected(this._context);

  State process(GameFieldControlsCard card) {
    _context.controlsState.update(CardsPlacingControls(
      totalMoney: _context.money.totalSum,
      card: card,
      nation: _context.nation,
    ));

    final cellsImpossibleToBuild = switch (card) {
      GameFieldControlsUnitCard() ||
      GameFieldControlsUnitCardBrief() =>
        UnitBuildCalculator(_context.gameField, _context.nation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.totalSum,
        ),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        ProductionCentersBuildCalculator(_context.gameField, _context.nation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.totalSum),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        TerrainModifierBuildCalculator(_context.gameField, _context.nation)
            .getAllCellsImpossibleToBuild(card.type, _context.money.totalSum),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        UnitBoosterBuildCalculator(_context.gameField, _context.nation).getAllCellsImpossibleToBuild(
          card.type,
          _context.money.totalSum,
        ),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesBuildCalculator(
          _context.gameField,
          _context.nation,
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
