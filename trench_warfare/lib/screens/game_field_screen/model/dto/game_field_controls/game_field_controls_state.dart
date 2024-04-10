part of game_field_controls;

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class MainControls extends GameFieldControlsState {
  final MoneyUnit money;

  final GameFieldControlsCellInfo? cellInfo;

  final GameFieldControlsArmyInfo? armyInfo;

  MainControls({
    required this.money,
    required this.cellInfo,
    required this.armyInfo,
  });
}

class Cards extends GameFieldControlsState {
  final MoneyUnit totalMoney;

  final List<GameFieldControlsUnitCard> units;

  final List<GameFieldControlsProductionCentersCard> productionCenters;

  final List<GameFieldControlsTerrainModifiersCard> terrainModifiers;

  final List<GameFieldControlsTroopBoostersCard> troopBoosters;

  final List<GameFieldControlsSpecialStrikesCard> specialStrikes;

  Cards({
    required this.totalMoney,
    required this.units,
    required this.productionCenters,
    required this.terrainModifiers,
    required this.troopBoosters,
    required this.specialStrikes,
  });
}
