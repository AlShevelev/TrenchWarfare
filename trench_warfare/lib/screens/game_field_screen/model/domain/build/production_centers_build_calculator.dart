part of build_calculators;

class ProductionCentersBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  ProductionCentersBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError() => AppropriateCell();

  bool canBuildOnCell(GameFieldCellRead cell, ProductionCenterType type) {
    if (cell.nation == null || cell.nation != _myNation) {
      return false;
    }

    if (cell.terrainModifier != null) {
      return false;
    }

    if (cell.activeUnit != null) {
      return false;
    }

    if (cell.productionCenter != null && cell.productionCenter!.type != type) {
      return false;
    }

    if (cell.productionCenter != null &&
        cell.productionCenter!.type == type &&
        cell.productionCenter!.level == ProductionCenter.getMaxLevel(type)) {
      return false;
    }

    switch (type) {
      case ProductionCenterType.city:
        {
          if (!cell.isLand) {
            return false;
          }

          if (cell.hasRiver || cell.hasRoad) {
            return false;
          }

          if (cell.terrain == CellTerrain.marsh || cell.terrain == CellTerrain.mountains) {
            return false;
          }

          return true;
        }
      case ProductionCenterType.factory:
        {
          if (!cell.isLand) {
            return false;
          }

          if (cell.hasRiver || cell.hasRoad) {
            return false;
          }

          if (cell.terrain == CellTerrain.wood ||
              cell.terrain == CellTerrain.marsh ||
              cell.terrain == CellTerrain.sand ||
              cell.terrain == CellTerrain.mountains) {
            return false;
          }

          return true;
        }
      case ProductionCenterType.airField:
        {
          if (!cell.isLand) {
            return false;
          }

          if (cell.hasRiver || cell.hasRoad) {
            return false;
          }

          if (cell.terrain == CellTerrain.marsh ||
              cell.terrain == CellTerrain.hills ||
              cell.terrain == CellTerrain.mountains ||
              cell.terrain == CellTerrain.snow) {
            return false;
          }

          return true;
        }
      case ProductionCenterType.navalBase:
        {
          if (cell.isLand) {
            return false;
          }

          // A naval base must be nearby a landmass
          return _gameField.findCellsAround(cell).any((c) => c.isLand);
        }
    }
  }

  bool canBuildOnGameField(ProductionCenterType type) {
    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, type)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(ProductionCenterType type) =>
      _gameField.cells.where((c) => canBuildOnCell(c, type)).toList(growable: false);

  List<GameFieldCellRead> getAllCellsImpossibleToBuild(ProductionCenterType type, MoneyUnit nationMoney) {
    return _gameField.cells.where((c) {
      final nextLevel = ProductionCenter.getNextLevel(type, c.productionCenter?.level);

      MoneyUnit? buildCost;
      if (nextLevel != null) {
        buildCost = MoneyProductionCenterCalculator.calculateBuildCost(c.terrain, type, nextLevel);
      }

      final cantBuild = !canBuildOnCell(c, type);

      if (buildCost == null) {
        return cantBuild;
      } else {
        return nationMoney.currency < buildCost.currency || nationMoney.industryPoints < buildCost.industryPoints || cantBuild;
      }
    }).toList(growable: false);
  }
}
