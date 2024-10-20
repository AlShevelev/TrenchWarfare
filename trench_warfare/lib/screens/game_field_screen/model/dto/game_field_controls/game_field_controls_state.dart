part of game_field_controls;

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class MainControls extends GameFieldControlsState {
  final MoneyUnit totalSum;

  final GameFieldControlsCellInfo? cellInfo;
  final GameFieldControlsArmyInfo? armyInfo;
  final GameFieldControlsArmyInfo? carrierInfo;

  MainControls({
    required this.totalSum,
    required this.cellInfo,
    required this.armyInfo,
    required this.carrierInfo,
  });

  MainControls copyCarrierInfo(GameFieldControlsArmyInfo? carrierInfo) => MainControls(
        totalSum: totalSum,
        cellInfo: cellInfo,
        armyInfo: armyInfo,
        carrierInfo: carrierInfo,
      );
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

class StartTurnControls extends GameFieldControlsState {
  final Nation nation;

  final int day;

  StartTurnControls({
    required this.nation,
    required this.day,
  });
}

class WinControls extends GameFieldControlsState {
  final Nation nation;

  WinControls({required this.nation});
}

class DefeatControls extends GameFieldControlsState {
  final Nation nation;

  final bool isGlobal;

  DefeatControls({required this.nation, required this.isGlobal});
}

class MenuControls extends GameFieldControlsState {
  final Nation nation;

  final int day;

  MenuControls({required this.nation, required this.day});
}
