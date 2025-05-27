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

class FromCardPlacingOnCellClicked {
  final GameFieldStateMachineContext _context;

  FromCardPlacingOnCellClicked(this._context);

  State process(
    Map<int, GameFieldCellRead> cellsImpossibleToBuild,
    GameFieldCell cell,
    GameFieldControlsCard card,
  ) {
    // do noting if a user clicked an invalid cell
    if (cellsImpossibleToBuild.containsKey(cell.id)) {
      return CardPlacing(card, cellsImpossibleToBuild);
    }

    final animationTime = _context.animationTimeFacade.getAnimationTime(!_context.isAI);

    final PlacingCalculator calculator = switch (card) {
      GameFieldControlsUnitCard() || GameFieldControlsUnitCardBrief() => CardPlacingCalculator(
          strategy: UnitsCardsPlacingStrategy(
            card: card as GameFieldControlsCard<UnitType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.myNation,
            unitUpdateResultBridge: _context.unitUpdateResultBridge,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
          animationTime: animationTime,
        ),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        CardPlacingCalculator(
          strategy: UnitBoostCardsPlacingStrategy(
            card: card as GameFieldControlsCard<UnitBoost>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.myNation,
            unitUpdateResultBridge: _context.unitUpdateResultBridge,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
          animationTime: animationTime,
        ),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        CardPlacingCalculator(
          strategy: TerrainModifierCardsPlacingStrategy(
            card: card as GameFieldControlsCard<TerrainModifierType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.myNation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
          animationTime: animationTime,
        ),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        CardPlacingCalculator(
          strategy: ProductionCenterCardsPlacingStrategy(
            card: card as GameFieldControlsCard<ProductionCenterType>,
            cell: cell,
            nationMoney: _context.money,
            gameField: _context.gameField,
            myNation: _context.myNation,
          ),
          updateGameObjectsEvent: _context.updateGameObjectsEvent,
          oldInactiveCells: cellsImpossibleToBuild,
          isAI: _context.isAI,
          animationTime: animationTime,
        ),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesStartCalculator(
          strategy: switch ((card as GameFieldControlsCard<SpecialStrikeType>).type) {
            SpecialStrikeType.airBombardment => AirBombardmentCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
                animationTime,
                _context.unitUpdateResultBridge,
                _context.myNation,
              ),
            SpecialStrikeType.flechettes => FlechettesCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
                animationTime,
                _context.unitUpdateResultBridge,
                _context.myNation,
              ),
            SpecialStrikeType.flameTroopers => FlameTroopersCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.isAI,
                animationTime,
                _context.unitUpdateResultBridge,
                _context.myNation,
              ),
            SpecialStrikeType.gasAttack => GasAttackCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.gameField,
                _context.isAI,
                animationTime,
                _context.unitUpdateResultBridge,
                _context.myNation,
              ),
            SpecialStrikeType.propaganda => PropagandaCardPlacingStrategy(
                _context.updateGameObjectsEvent,
                cell,
                _context.gameField,
                _context.isAI,
                animationTime,
                _context.unitUpdateResultBridge,
                _context.myNation,
              ),
          },
          oldInactiveCells: cellsImpossibleToBuild,
          gameField: _context.gameField,
          myNation: _context.myNation,
          mapMetadata: _context.mapMetadata,
          nationMoney: _context.money,
          card: card,
        ),
      _ => throw UnsupportedError(''),
    };

    return calculator.place();
  }
}
