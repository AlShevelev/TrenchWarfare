part of game_field_sm;

class FromCardSelectingOnCardsSelected extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final Nation _nation;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  late final MapMetadataRead _mapMetadata;

  FromCardSelectingOnCardsSelected(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyUnit nationMoney,
    required Nation nation,
    required SimpleStream<GameFieldControlsState> controlsState,
    required MapMetadataRead mapMetadata,
  }) {
    _nationMoney = nationMoney;
    _nation = nation;
    _controlsState = controlsState;
    _mapMetadata = mapMetadata;
  }

  State process(GameFieldControlsCard card) {
    _controlsState.update(CardsPlacingControls(
      totalMoney: _nationMoney,
      card: card,
    ));

    final cellsImpossibleToBuild = switch (card) {
      GameFieldControlsUnitCard() ||
      GameFieldControlsUnitCardBrief() =>
        UnitBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type, _nationMoney),
      GameFieldControlsProductionCentersCard() ||
      GameFieldControlsProductionCentersCardBrief() =>
        ProductionCentersBuildCalculator(_gameField, _nation)
            .getAllCellsImpossibleToBuild(card.type, _nationMoney),
      GameFieldControlsTerrainModifiersCard() ||
      GameFieldControlsTerrainModifiersCardBrief() =>
        TerrainModifierBuildCalculator(_gameField, _nation)
            .getAllCellsImpossibleToBuild(card.type, _nationMoney),
      GameFieldControlsUnitBoostersCard() ||
      GameFieldControlsUnitBoostersCardBrief() =>
        UnitBoosterBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type, _nationMoney),
      GameFieldControlsSpecialStrikesCard() ||
      GameFieldControlsSpecialStrikesCardBrief() =>
        SpecialStrikesBuildCalculator(_gameField, _nation, _mapMetadata)
            .getAllCellsImpossibleToBuild(card.type, _nationMoney),
      _ => throw UnsupportedError(''),
    };

    final cellsImpossibleToBuildMap = {for (var e in cellsImpossibleToBuild) e.id: e};

    _updateGameObjectsEvent.update([
      UpdateCellInactivity(
        newInactiveCells: cellsImpossibleToBuildMap,
        oldInactiveCells: {},
      )
    ]);

    return CardPlacing(card, cellsImpossibleToBuildMap);
  }
}
