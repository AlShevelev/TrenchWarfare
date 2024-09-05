part of pathfinding;

class SeaFindPathSettings implements FindPathSettings {
  final GameFieldCellRead _startCell;

  final UnitType _unit;

  SeaFindPathSettings({required GameFieldCellRead startCell, required Unit calculatedUnit})
      : _startCell = startCell,
        _unit = calculatedUnit.type;

  @override
  double? calculateGFactorHeuristic(GameFieldCellRead priorCell, GameFieldCellRead nextCell) {
    if (!isCellReachable(nextCell)) {
      return null;
    }

    // Try to avoid mine fields
    if (nextCell.terrainModifier?.type == TerrainModifierType.seaMine) {
      return 8;
    }

    // Try to avoid enemy formations
    if (nextCell.nation != null && nextCell.nation != _startCell.nation && _startCell.units.isNotEmpty) {
      return 8;
    }

    return 1;
  }

  @override
  bool isCellReachable(GameFieldCellRead cell) =>
      SeaFindPathSettings.isCellReachableStatic(_unit, cell: cell, startCell: _startCell);

  static bool canContainSeaUnit(GameFieldCellRead cell) => !(cell.isLand && !cell.hasRiver);

  static bool isCellReachableStatic(
    UnitType calculatedUnitType, {
    required GameFieldCellRead startCell,
    required GameFieldCellRead cell,
  }) {
    if (cell.isLand && !cell.hasRiver) {
      return false;
    }

    if (cell.nation == startCell.nation && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    if (calculatedUnitType == UnitType.carrier &&
        cell.activeUnit != null &&
        startCell.nation != cell.nation) {
      return false;
    }

    return true;
  }
}
