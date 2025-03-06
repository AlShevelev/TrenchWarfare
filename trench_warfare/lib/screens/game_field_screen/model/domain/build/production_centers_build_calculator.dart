part of build_calculators;

class ProductionCentersBuildCalculator {
  final GameFieldRead _gameField;

  final Nation _myNation;

  ProductionCentersBuildCalculator(this._gameField, this._myNation);

  BuildRestriction getError() => AppropriateCell();

  /// Returns all the cells where we can build or upgrade a production center
  /// (excluding money calculations)
  List<GameFieldCellRead> getAllCellsToBuild(ProductionCenterType type) =>
      _gameField.cells.where((c) => _canBuildOnCell(c, type)).toList(growable: false);

  /// Returns all the cells where we can build or upgrade a production center
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsPossibleToBuild(ProductionCenterType type, MoneyUnit nationMoney) {
    final allImpossibleIds = getAllCellsImpossibleToBuild(type, nationMoney).map((c) => c.id).toSet();
    return _gameField.cells.where((c) => !allImpossibleIds.contains(c.id)).toList(growable: false);
  }

  /// Returns all the cells where we can't build or upgrade a production center
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsImpossibleToBuild(ProductionCenterType type, MoneyUnit nationMoney) {
    return _gameField.cells.where((c) {
      final nextLevel = ProductionCenter.getNextLevel(type, c.productionCenter?.level);

      MoneyUnit? buildCost;
      if (nextLevel != null) {
        buildCost = MoneyProductionCenterCalculator.calculateBuildCost(c.terrain, type, nextLevel);
      }

      final cantBuild = !_canBuildOnCell(c, type);

      if (buildCost == null) {
        return cantBuild;
      } else {
        return nationMoney.currency < buildCost.currency || nationMoney.industryPoints < buildCost.industryPoints || cantBuild;
      }
    }).toList(growable: false);
  }

  bool _canBuildOnCell(GameFieldCellRead cell, ProductionCenterType type) {
    if (cell.nation == null || cell.nation != _myNation) {
      return false;
    }

    if (cell.terrainModifier != null) {
      return false;
    }

    if (cell.productionCenter != null && cell.productionCenter!.type != type) {
      return false;
    }

    var upgrade = false;
    if (cell.productionCenter != null &&
        cell.productionCenter!.type == type) {
      if (cell.productionCenter!.level == ProductionCenter.getMaxLevel(type)) {
        return false;
      } else {
        upgrade = true;
      }
    }

    var canBuildOrUpgrade = true;
    switch (type) {
      case ProductionCenterType.city:
        {
          if (!cell.isLand) {
            canBuildOrUpgrade = false;
          }

          if (cell.hasRiver) {
            canBuildOrUpgrade = false;
          }

          if (cell.terrain == CellTerrain.marsh || cell.terrain == CellTerrain.mountains) {
            canBuildOrUpgrade = false;
          }
        }
      case ProductionCenterType.factory:
        {
          if (!cell.isLand) {
            canBuildOrUpgrade = false;
          }

          if (cell.hasRiver) {
            canBuildOrUpgrade = false;
          }

          if (cell.terrain == CellTerrain.wood ||
              cell.terrain == CellTerrain.marsh ||
              cell.terrain == CellTerrain.sand ||
              cell.terrain == CellTerrain.mountains) {
            canBuildOrUpgrade = false;
          }
        }
      case ProductionCenterType.airField:
        {
          if (!cell.isLand) {
            canBuildOrUpgrade = false;
          }

          if (cell.hasRiver) {
            canBuildOrUpgrade = false;
          }

          if (cell.terrain == CellTerrain.marsh ||
              cell.terrain == CellTerrain.hills ||
              cell.terrain == CellTerrain.mountains ||
              cell.terrain == CellTerrain.snow) {
            canBuildOrUpgrade = false;
          }
        }
      case ProductionCenterType.navalBase:
        {
          if (cell.isLand) {
            canBuildOrUpgrade = false;
          } else {
            // A naval base must be nearby a landmass
            canBuildOrUpgrade = _gameField.findCellsAround(cell).any((c) => c.isLand);
          }
        }
    }

    if (canBuildOrUpgrade) {
      // We can't build a PC in a cell with units
      if (!upgrade && cell.activeUnit != null) {
        return false;
      } else  {
        // But we can upgrade the PC
        return true;
      }
    }

    return false;
  }
}
