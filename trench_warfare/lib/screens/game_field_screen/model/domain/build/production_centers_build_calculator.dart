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
}
