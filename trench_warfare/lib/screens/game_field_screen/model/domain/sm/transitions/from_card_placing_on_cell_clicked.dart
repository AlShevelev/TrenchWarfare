part of game_field_sm;

class FromCardPlacingOnCellClicked extends GameObjectTransitionBase {
  late final MoneyStorage _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  late final Nation _myNation;

  late final MapMetadataRead _mapMetadata;

  FromCardPlacingOnCellClicked(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyStorage nationMoney,
    required SimpleStream<GameFieldControlsState> controlsState,
    required Nation myNation,
    required MapMetadataRead mapMetadata,
  }) {
    _nationMoney = nationMoney;
    _controlsState = controlsState;
    _myNation = myNation;
    _mapMetadata = mapMetadata;
  }

  State process(
    Map<int, GameFieldCellRead> cellsImpossibleToBuild,
    GameFieldCell cell,
    GameFieldControlsCard card,
  ) {
    // do noting if a user clicked an invalid cell
    if (cellsImpossibleToBuild.containsKey(cell.id)) {
      return CardPlacing(card, cellsImpossibleToBuild);
    }

    final PlacingCalculator calculator = switch (card) {
      GameFieldControlsUnitCard() => CardPlacingCalculator(
          strategy: UnitsCardsPlacingStrategy(
            card: card,
            cell: cell,
            nationMoney: _nationMoney,
            gameField: _gameField,
            myNation: _myNation,
          ),
          updateGameObjectsEvent: _updateGameObjectsEvent,
          controlsState: _controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
        ),
      GameFieldControlsUnitBoostersCard() => CardPlacingCalculator(
          strategy: UnitBoostCardsPlacingStrategy(
            card: card,
            cell: cell,
            nationMoney: _nationMoney,
            gameField: _gameField,
            myNation: _myNation,
          ),
          updateGameObjectsEvent: _updateGameObjectsEvent,
          controlsState: _controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
        ),
      GameFieldControlsTerrainModifiersCard() => CardPlacingCalculator(
          strategy: TerrainModifierCardsPlacingStrategy(
            card: card,
            cell: cell,
            nationMoney: _nationMoney,
            gameField: _gameField,
            myNation: _myNation,
          ),
          updateGameObjectsEvent: _updateGameObjectsEvent,
          controlsState: _controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
        ),
      GameFieldControlsProductionCentersCard() => CardPlacingCalculator(
          strategy: ProductionCenterCardsPlacingStrategy(
            card: card,
            cell: cell,
            nationMoney: _nationMoney,
            gameField: _gameField,
            myNation: _myNation,
          ),
          updateGameObjectsEvent: _updateGameObjectsEvent,
          controlsState: _controlsState,
          oldInactiveCells: cellsImpossibleToBuild,
        ),
      GameFieldControlsSpecialStrikesCard() => SpecialStrikesStartCalculator(
          strategy: switch (card.type) {
            SpecialStrikeType.airBombardment =>
              AirBombardmentCardPlacingStrategy(_updateGameObjectsEvent, cell),
            SpecialStrikeType.flechettes => FlechettesCardPlacingStrategy(_updateGameObjectsEvent, cell),
            SpecialStrikeType.flameTroopers =>
              FlameTroopersCardPlacingStrategy(_updateGameObjectsEvent, cell),
            SpecialStrikeType.gasAttack =>
              GasAttackCardPlacingStrategy(_updateGameObjectsEvent, cell, _gameField),
            SpecialStrikeType.propaganda => PropagandaCardPlacingStrategy(
                _updateGameObjectsEvent,
                cell,
                _gameField,
                _myNation,
              ),
          },
          oldInactiveCells: cellsImpossibleToBuild,
          gameField: _gameField,
          myNation: _myNation,
          mapMetadata: _mapMetadata,
          nationMoney: _nationMoney,
          card: card,
        ),
      _ => throw UnsupportedError(''),
    };

    return calculator.place();
  }
}
