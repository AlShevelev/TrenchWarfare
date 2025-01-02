part of cards_placing;

class ProductionCenterCardsPlacingStrategy
    extends CardsPlacingStrategy<GameFieldControlsCard<ProductionCenterType>, ProductionCenterType> {
  ProductionCenterCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
  });

  late final ProductionCenter productionCenter;

  @override
  MoneyUnit calculateProductionCost() =>
      MoneyProductionCenterCalculator.calculateBuildCost(_cell.terrain, _type, productionCenter.level)!;

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      ProductionCentersBuildCalculator(_gameField, _myNation)
          .getAllCellsImpossibleToBuild(_type, _nationMoney.totalSum);

  @override
  void updateCell() {
    productionCenter = _calculateProductionCenter(_cell.productionCenter, _type)!;
    _cell.setProductionCenter(productionCenter);
  }

  ProductionCenter? _calculateProductionCenter(
      ProductionCenter? productionCenter,
      ProductionCenterType type,
      ) {
    if (productionCenter == null) {
      return ProductionCenter(type: type, level: ProductionCenterLevel.level1, name: '');
    } else {
      return productionCenter.nextLevel
          ?.let((l) => ProductionCenter(type: type, level: l, name: productionCenter.name));
    }
  }

  @override
  PlaySound? getSoundForUnit() => PlaySound(type: SoundType.productionPC);
}
