part of cards_placing;

abstract interface class CardsPlacingStrategy<C extends GameFieldControlsCard<T>, T> {
  @protected
  late final C _card;
  C get card => _card;

  @protected
  T get _type => _card.type;

  @protected
  late final GameFieldCell _cell;
  GameFieldCell get cell => _cell;

  @protected
  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  @protected
  late final Nation _myNation;
  Nation get myNation => _myNation;

  @protected
  late final MoneyStorage _nationMoney;
  MoneyStorage get nationMoney => _nationMoney;

  CardsPlacingStrategy({
    required C card,
    required GameFieldCell cell,
    required MoneyStorage nationMoney,
    required GameFieldRead gameField,
    required Nation myNation,
  }) {
    _card = card;
    _cell = cell;
    _nationMoney = nationMoney;
    _gameField = gameField;
    _myNation = myNation;
  }

  void updateCell();

  MoneyUnit calculateProductionCost();

  List<GameFieldCellRead> getAllCellsImpossibleToBuild();
}

class UnitsCardsPlacingStrategy extends CardsPlacingStrategy<GameFieldControlsCard<UnitType>, UnitType> {
  UnitsCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
  });

  @override
  MoneyUnit calculateProductionCost() => MoneyUnitsCalculator.calculateProductionCost(_card.type);

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      UnitBuildCalculator(_gameField, _myNation).getAllCellsImpossibleToBuild(_type, _nationMoney.actual);

  @override
  void updateCell() {
    final unit = _type == UnitType.carrier ? Carrier.create() : Unit.byType(_type);
    _cell.addUnitAsActive(unit);
  }
}

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
      .getAllCellsImpossibleToBuild(_type, _nationMoney.actual);

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
}

class TerrainModifierCardsPlacingStrategy
    extends CardsPlacingStrategy<GameFieldControlsCard<TerrainModifierType>, TerrainModifierType> {
  TerrainModifierCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
  });

  @override
  MoneyUnit calculateProductionCost() =>
      MoneyTerrainModifierCalculator.calculateBuildCost(_cell.terrain, _type)!;

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      TerrainModifierBuildCalculator(_gameField, _myNation)
          .getAllCellsImpossibleToBuild(_type, _nationMoney.actual);

  @override
  void updateCell() => _cell.setTerrainModifier(TerrainModifier(type: _type));
}

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
          .getAllCellsImpossibleToBuild(_type, _nationMoney.actual);

  @override
  void updateCell() {
    log('AI_PEACEFUL 6. ProductionCenterCardsPlacingStrategy updateCell _type: $_type');
    productionCenter = _calculateProductionCenter(_cell.productionCenter, _type)!;
    log('AI_PEACEFUL 7. ProductionCenterCardsPlacingStrategy updateCell setProductionCenter type: ${productionCenter.type}');
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
}
