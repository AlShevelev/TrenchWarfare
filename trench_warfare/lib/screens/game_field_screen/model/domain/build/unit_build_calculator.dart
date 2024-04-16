part of build_calculators;

class UnitBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  UnitBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  static BuildRestriction getRestriction(UnitType unitType) => switch (unitType) {
        UnitType.armoredCar => BuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.artillery => BuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.infantry => BuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cavalry => BuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.machineGunnersCart => BuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.machineGuns => BuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.tank => BuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level4,
          ),
        UnitType.destroyer => BuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cruiser => BuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.battleship => BuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.carrier => BuildRestriction(
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

    final restriction = getRestriction(unitType);

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
}
