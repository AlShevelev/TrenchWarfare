part of cards_placing;

class UnitsCardsPlacingStrategy extends CardsPlacingStrategy<GameFieldControlsCard<UnitType>, UnitType> {
  final UnitUpdateResultBridge? _unitUpdateResultBridge;

  UnitsCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
    required UnitUpdateResultBridge? unitUpdateResultBridge,
  }) : _unitUpdateResultBridge = unitUpdateResultBridge;

  @override
  MoneyUnit calculateProductionCost() => MoneyUnitsCalculator.calculateProductionCost(_card.type);

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      UnitBuildCalculator(_gameField, _myNation).getAllCellsImpossibleToBuild(_type, _nationMoney.totalSum);

  @override
  void updateCell() {
    final unit = _type == UnitType.carrier ? Carrier.create() : Unit.byType(_type);
    _cell.addUnitAsActive(unit);

    _unitUpdateResultBridge?.addAfter(nation: _myNation, unit: Unit.copy(unit), cell: _cell);
  }

  @override
  PlaySound? getSoundForUnit() => PlaySound(type: Unit.byType(_type).getProductionSoundType());
}
