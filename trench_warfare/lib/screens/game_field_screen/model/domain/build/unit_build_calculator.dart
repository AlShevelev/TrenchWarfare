part of build_calculators;

class UnitBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  UnitBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getRestriction(UnitType unitType) => switch (unitType) {
        UnitType.armoredCar => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.artillery => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.infantry => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cavalry => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.machineGunnersCart => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.machineGuns => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.city,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.tank => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.factory,
            productionCenterLevel: ProductionCenterLevel.level4,
          ),
        UnitType.destroyer => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level1,
          ),
        UnitType.cruiser => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        UnitType.battleship => UnitBuildRestriction(
            productionCenterType: ProductionCenterType.navalBase,
            productionCenterLevel: ProductionCenterLevel.level3,
          ),
        UnitType.carrier => UnitBuildRestriction(
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

    final restriction = getRestriction(unitType) as UnitBuildRestriction;

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

  List<GameFieldCellRead> getAllCellsToBuild(UnitType unitType) {
    final List<GameFieldCellRead> result = [];

    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, unitType)) {
        result.add(cell);
      }
    }

    return result;
  }
}
