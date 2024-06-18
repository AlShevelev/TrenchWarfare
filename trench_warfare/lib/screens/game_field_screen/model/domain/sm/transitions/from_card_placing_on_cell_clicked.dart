part of game_field_sm;

class FromCardPlacingOnCellClicked extends GameObjectTransitionBase {
  FromCardPlacingOnCellClicked(super.context);

  State process(
    Map<int, GameFieldCellRead> cellsImpossibleToBuild,
    GameFieldCell cell,
    GameFieldControlsCard card,
  ) {
    log('AI_PEACEFUL 5. FromCardPlacingOnCellClicked process(${card.type})');

    // do noting if a user clicked an invalid cell
    if (cellsImpossibleToBuild.containsKey(cell.id)) {
      log('AI_PEACEFUL 51. return CardPlacing in FromCardPlacingOnCellClicked');
      return CardPlacing(card, cellsImpossibleToBuild);
    }

    final PlacingCalculator calculator = switch (card) {
      GameFieldControlsUnitCard() || GameFieldControlsUnitCardBrief() => CardPlacingCalculator(
          strategy: UnitsCardsPlacingStrategy(
            card: card as GameFieldControlsCard<UnitType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.nation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          controlsState: _context.controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
        ),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        CardPlacingCalculator(
          strategy: UnitBoostCardsPlacingStrategy(
            card: card as GameFieldControlsCard<UnitBoost>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.nation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          controlsState: _context.controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
        ),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        CardPlacingCalculator(
          strategy: TerrainModifierCardsPlacingStrategy(
            card: card as GameFieldControlsCard<TerrainModifierType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.nation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          controlsState: _context.controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
        ),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        CardPlacingCalculator(
          strategy: ProductionCenterCardsPlacingStrategy(
            card: card as GameFieldControlsCard<ProductionCenterType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.nation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          controlsState: _context.controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
        ),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesStartCalculator(
          strategy: switch ((card as GameFieldControlsCard<SpecialStrikeType>).type) {
            SpecialStrikeType.airBombardment => AirBombardmentCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
              ),
            SpecialStrikeType.flechettes => FlechettesCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
              ),
            SpecialStrikeType.flameTroopers => FlameTroopersCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
              ),
            SpecialStrikeType.gasAttack => GasAttackCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.gameField,
                _context.isAI,
              ),
            SpecialStrikeType.propaganda => PropagandaCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.gameField,
                _context.nation,
                _context.isAI,
              ),
          },
          oldInactiveCells: cellsImpossibleToBuild,
          gameField: _context.gameField,
          myNation: _context.nation,
          mapMetadata: _context.mapMetadata,
          nationMoney: _context.money,
          card: card,
        ),
      _ => throw UnsupportedError(''),
    };

    return calculator.place();
  }
}
