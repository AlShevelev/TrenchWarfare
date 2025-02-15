part of cards_placing;

class UnitBoostCardsPlacingStrategy
    extends CardsPlacingStrategy<GameFieldControlsCard<UnitBoost>, UnitBoost> {
  UnitBoostCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
  });

  @override
  MoneyUnit calculateProductionCost() => MoneyUnitBoostCalculator.calculateCost(_type);

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() => UnitBoosterBuildCalculator(_gameField, _myNation)
      .getAllCellsImpossibleToBuild(_type, _nationMoney.totalSum);

  @override
  void updateCell() => _cell.activeUnit?.setBoost(_type);

  @override
  PlaySound? getSoundForUnit() => PlaySound(type: SoundType.dingUniversal);
}
