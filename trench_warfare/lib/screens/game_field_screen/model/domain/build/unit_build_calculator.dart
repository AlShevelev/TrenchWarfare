part of build_calculators;

class UnitBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  UnitBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError(UnitType unitType) => getRestriction(unitType);

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

    return pc.type == restriction.productionCenterType && pc.level >= restriction.productionCenterLevel;
  }

  bool canBuildOnGameField(UnitType unitType) {
    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, unitType)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(UnitType unitType) =>
    _gameField.cells.where((c) => canBuildOnCell(c, unitType)).toList(growable: false);
}
