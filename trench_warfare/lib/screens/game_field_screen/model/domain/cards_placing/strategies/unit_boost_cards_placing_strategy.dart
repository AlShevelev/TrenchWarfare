/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of cards_placing;

class UnitBoostCardsPlacingStrategy
    extends CardsPlacingStrategy<GameFieldControlsCard<UnitBoost>, UnitBoost> {

  final UnitUpdateResultBridge? _unitUpdateResultBridge;

  UnitBoostCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
    required UnitUpdateResultBridge? unitUpdateResultBridge,
  }) : _unitUpdateResultBridge = unitUpdateResultBridge;

  @override
  MoneyUnit calculateProductionCost() => MoneyUnitBoostCalculator.calculateCost(_type);

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      UnitBoosterBuildCalculator(_gameField, _myNation)
          .getAllCellsImpossibleToBuild(_type, _nationMoney.totalSum);

  @override
  void updateCell() {
    _unitUpdateResultBridge?.addBefore(nation: _myNation, unit: Unit.copy(_cell.activeUnit!), cell: _cell);
    _cell.activeUnit!.setBoost(_type);
    _unitUpdateResultBridge?.addAfter(nation: _myNation, unit: Unit.copy(_cell.activeUnit!), cell: _cell);
  }

  @override
  PlaySound? getSoundForUnit() => PlaySound(type: SoundType.dingUniversal);
}
