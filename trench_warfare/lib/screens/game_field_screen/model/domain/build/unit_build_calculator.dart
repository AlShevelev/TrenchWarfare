part of build_calculators;

class UnitBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  bool _inappropriateCell = false;

  UnitBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError(UnitType unitType) => _inappropriateCell ? AppropriateCell() : getRestriction(unitType);

  BuildRestriction getRestriction(UnitType unitType) => switch (unitType) {
        UnitType.armoredCar => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.artillery => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.infantry => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cavalry => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.machineGunnersCart => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.machineGuns => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.tank => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level4,
          ),
        UnitType.destroyer => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cruiser => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.battleship => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.carrier => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
      };

  bool canBuildOnCell(GameFieldCellRead cell, UnitType unitType) {
    if (cell.nation != _myNation) {
      return false;
    }

    final pc = cell.productionCenter;

    if (pc == null) {
      return false;
    }

    final restriction = getRestriction(unitType) as ProductionCenterBuildRestriction;
    final hasProperProductionCenter = pc.type == restriction.productionCenterType && pc.level >= restriction.productionCenterLevel;

    if (!hasProperProductionCenter) {
      return false;
    }

    if (cell.units.length == GameConstants.maxUnitsInCell) {
      _inappropriateCell = true;
      return false;
    }

    return true;
  }

  bool canBuildOnGameField(UnitType unitType) {
    _inappropriateCell = false;

    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, unitType)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(UnitType unitType) =>
    _gameField.cells.where((c) => canBuildOnCell(c, unitType)).toList(growable: false);

  List<GameFieldCellRead> getAllCellsImpossibleToBuild(UnitType unitType, MoneyUnit nationMoney) {
    final buildCost = MoneyUnitsCalculator.calculateProductionCost(unitType);

    if (nationMoney.currency < buildCost.currency || nationMoney.industryPoints < buildCost.industryPoints) {
      return _gameField.cells.toList(growable: false);
    }

    return _gameField.cells.where((c) => !canBuildOnCell(c, unitType)).toList(growable: false);
  }
}
