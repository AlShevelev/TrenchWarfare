/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_controls;

sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class MainControls extends GameFieldControlsState {
  final MoneyUnit totalSum;

  final GameFieldControlsCellInfo? cellInfo;
  final GameFieldControlsArmyInfo? armyInfo;
  final GameFieldControlsArmyInfo? carrierInfo;

  final Nation nation;

  final bool showDismissButton;

  MainControls({
    required this.totalSum,
    required this.cellInfo,
    required this.armyInfo,
    required this.carrierInfo,
    required this.nation,
    required this.showDismissButton,
  });

  MainControls setCarrierInfo(GameFieldControlsArmyInfo? carrierInfo) => MainControls(
        totalSum: totalSum,
        cellInfo: cellInfo,
        armyInfo: armyInfo,
        carrierInfo: carrierInfo,
        nation: nation,
        showDismissButton: showDismissButton,
      );

  MainControls setShowDismissButton(bool showDismissButton) => MainControls(
        totalSum: totalSum,
        cellInfo: cellInfo,
        armyInfo: armyInfo,
        carrierInfo: carrierInfo,
        nation: nation,
        showDismissButton: showDismissButton,
      );
}

class CardsSelectionControls extends GameFieldControlsState {
  final MoneyUnit totalMoney;

  final List<GameFieldControlsUnitCard> units;

  final List<GameFieldControlsProductionCentersCard> productionCenters;

  final List<GameFieldControlsTerrainModifiersCard> terrainModifiers;

  final List<GameFieldControlsUnitBoostersCard> unitBoosters;

  final List<GameFieldControlsSpecialStrikesCard> specialStrikes;

  final Nation nation;

  CardsSelectionControls({
    required this.totalMoney,
    required this.units,
    required this.productionCenters,
    required this.terrainModifiers,
    required this.unitBoosters,
    required this.specialStrikes,
    required this.nation,
  });
}

class CardsPlacingControls extends GameFieldControlsState {
  final MoneyUnit totalMoney;

  final GameFieldControlsCard card;

  final Nation nation;

  CardsPlacingControls({
    required this.totalMoney,
    required this.card,
    required this.nation,
  });
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

class SaveControls extends GameFieldControlsState {
  SaveControls();
}

class ObjectivesControls extends GameFieldControlsState {
  final List<Nation> nations;

  ObjectivesControls({required this.nations});
}

class SettingsControls extends GameFieldControlsState {
  SettingsControls();
}

class EndOfTurnConfirmationControls extends GameFieldControlsState {
  EndOfTurnConfirmationControls();
}

class DisbandUnitConfirmationControls extends GameFieldControlsState {
  final Unit unitToShow;

  final Nation nation;

  DisbandUnitConfirmationControls({required this.unitToShow, required this.nation});
}

class AiTurnProgress extends GameFieldControlsState {
  final double moneySpending;
  final double unitMovement;

  AiTurnProgress({
    required this.moneySpending,
    required this.unitMovement,
  });

  AiTurnProgress copy({double? moneySpending, double? unitMovement}) => AiTurnProgress(
        moneySpending: moneySpending ?? this.moneySpending,
        unitMovement: unitMovement ?? this.unitMovement,
      );
}
