/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of build_calculators;

class UnitBoosterBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  UnitBoosterBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError() => AppropriateUnit();

  static bool canBuildForUnit(Unit unit, UnitBoost type) {
    if (unit.boost1 != null && unit.boost2 != null && unit.boost3 != null) {
      return false;
    }

    if (unit.boost1 == type || unit.boost2 == type || unit.boost3 == type) {
      return false;
    }

    if (type == UnitBoost.transport && !unit.isLand) {
      return false;
    }

    if (type == UnitBoost.transport &&
        unit.type != UnitType.infantry &&
        unit.type != UnitType.artillery &&
        unit.type != UnitType.machineGuns) {
      return false;
    }

    if ((type == UnitBoost.attack || type == UnitBoost.commander) && unit.type == UnitType.carrier) {
      return false;
    }

    return true;
  }

  bool _canBuildOnCell(GameFieldCellRead cell, UnitBoost type) {
    if (cell.nation != _myNation) {
      return false;
    }

    final activeUnit = cell.activeUnit;

    if (activeUnit == null) {
      return false;
    }

    return canBuildForUnit(activeUnit, type);
  }

  bool canBuildOnGameField(UnitBoost type) {
    for (var cell in _gameField.cells) {
      if (_canBuildOnCell(cell, type)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(UnitBoost type) =>
      _gameField.cells.where((c) => _canBuildOnCell(c, type)).toList(growable: false);

  /// Returns all the cells where we can place the booster
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsPossibleToBuild(UnitBoost type, MoneyUnit nationMoney) {
    final allImpossibleIds = getAllCellsImpossibleToBuild(type, nationMoney).map((c) => c.id).toSet();
    return _gameField.cells.where((c) => !allImpossibleIds.contains(c.id)).toList(growable: false);
  }

  /// Returns all the cells where we can't place the booster
  /// (including money calculations)
  List<GameFieldCellRead> getAllCellsImpossibleToBuild(UnitBoost type, MoneyUnit nationMoney) {
    final buildCost = MoneyUnitBoostCalculator.calculateCost(type);

    if (nationMoney.currency < buildCost.currency || nationMoney.industryPoints < buildCost.industryPoints) {
      return _gameField.cells.toList(growable: false);
    }

    return _gameField.cells.where((c) => !_canBuildOnCell(c, type)).toList(growable: false);
  }
}
