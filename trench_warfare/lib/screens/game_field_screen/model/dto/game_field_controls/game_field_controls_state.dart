part of game_field_controls;

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class MainControls extends GameFieldControlsState {
  final MoneyUnit money;

  final GameFieldControlsCellInfo? cellInfo;

  final GameFieldControlsArmyInfo? armyInfo;

  final GameFieldControlsArmyInfo? carrierInfo;

  MainControls({
    required this.money,
    required this.cellInfo,
    required this.armyInfo,
    required this.carrierInfo,
  });
}

class CardsSelectionControls extends GameFieldControlsState {
  final MoneyUnit totalMoney;

  final List<GameFieldControlsUnitCard> units;

  final List<GameFieldControlsProductionCentersCard> productionCenters;

  final List<GameFieldControlsTerrainModifiersCard> terrainModifiers;

  final List<GameFieldControlsUnitBoostersCard> unitBoosters;

  final List<GameFieldControlsSpecialStrikesCard> specialStrikes;

  CardsSelectionControls({
    required this.totalMoney,
    required this.units,
    required this.productionCenters,
    required this.terrainModifiers,
    required this.unitBoosters,
    required this.specialStrikes,
  });
}

class CardsPlacingControls extends GameFieldControlsState {
  final MoneyUnit totalMoney;

  final GameFieldControlsCard card;

  CardsPlacingControls({required this.totalMoney, required this.card});
}
