part of pathfinding;

class SeaFindPathSettings implements FindPathSettings {
  late final GameFieldCellRead _startCell;

  SeaFindPathSettings({required GameFieldCellRead startCell}) {
    _startCell = startCell;
  }

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
      SeaFindPathSettings.isCellReachableStatic(cell: cell, startCell: _startCell);

  static bool isCellReachableStatic({
    required GameFieldCellRead startCell,
    required GameFieldCellRead cell,
  }) {
    if (cell.isLand && !cell.hasRiver) {
      return false;
    }

    if (cell.nation == startCell.nation! && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    final activeUnit = startCell.activeUnit!;
    if (activeUnit.type == UnitType.carrier && cell.activeUnit != null && startCell.nation != cell.nation) {
      return false;
    }

    return true;
  }
}
