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
  void updateCell() {
    final activeUnit = _cell.activeUnit!;

    // Set the boost
    if (activeUnit.boost1 == null) {
      activeUnit.setBoost1(_type);
    } else if (activeUnit.boost2 == null) {
      activeUnit.setBoost2(_type);
    } else if (activeUnit.boost3 == null) {
      activeUnit.setBoost3(_type);
    }
  }

  @override
  PlaySound? getSoundForUnit() => PlaySound(type: SoundType.dingUniversal);
}
