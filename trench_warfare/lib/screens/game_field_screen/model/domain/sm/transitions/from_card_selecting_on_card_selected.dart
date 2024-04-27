part of game_field_sm;

class FromCardSelectingOnCardsSelected extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final Nation _nation;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final MapMetadataRead _mapMetadata;

  FromCardSelectingOnCardsSelected(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyUnit nationMoney,
    required Nation nation,
    required SingleStream<GameFieldControlsState> controlsState,
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
      GameFieldControlsUnitCard() => UnitBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type),
      GameFieldControlsProductionCentersCard() =>
        ProductionCentersBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type),
      GameFieldControlsTerrainModifiersCard() =>
        TerrainModifierBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type),
      GameFieldControlsUnitBoostersCard() =>
        UnitBoosterBuildCalculator(_gameField, _nation).getAllCellsImpossibleToBuild(card.type),
      GameFieldControlsSpecialStrikesCard() =>
        SpecialStrikesBuildCalculator(_gameField, _nation, _mapMetadata).getAllCellsImpossibleToBuild(card.type),
      _ => throw UnsupportedError(''),
    };

    final cellsImpossibleToBuildIds = { for (var e in cellsImpossibleToBuild) e.id : e };

    _updateGameObjectsEvent.update([
      UpdateCellInactivity(
        newInactiveCells: cellsImpossibleToBuildIds,
        oldInactiveCells: {},
      )
    ]);

    return CardPlacing(card, cellsImpossibleToBuildIds);
  }
}
