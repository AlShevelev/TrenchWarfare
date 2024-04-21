part of build_calculators;

class UnitBoosterBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  UnitBoosterBuildCalculator(GameFieldRead gameField, Nation myNation) {
    _gameField = gameField;
    _myNation = myNation;
  }

  BuildRestriction getError() => AppropriateUnit();

  bool canBuildOnCell(GameFieldCellRead cell, UnitBoost type) {
    if (cell.nation != _myNation) {
      return false;
    }

    final activeUnit = cell.activeUnit;

    if (activeUnit == null) {
      return false;
    }

    if (activeUnit.boost1 != null && activeUnit.boost2 != null && activeUnit.boost3 != null) {
      return false;
    }

    if (activeUnit.boost1 == type || activeUnit.boost2 == type || activeUnit.boost3 == type) {
      return false;
    }

    return true;
  }

  bool canBuildOnGameField(UnitBoost type) {
    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, type)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(UnitBoost type) =>
    _gameField.cells.where((c) => canBuildOnCell(c, type)).toList(growable: false);
}