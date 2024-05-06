part of pathfinding;

class SeaFindPathSettings implements FindPathSettings {
  late final GameFieldCell _startCell;

  @protected
  Unit get _activeUnit => _startCell.activeUnit!;

  SeaFindPathSettings({required GameFieldCell startCell}) {
    _startCell = startCell;
  }

  @override
  double? calculateGFactorHeuristic(GameFieldCell priorCell, GameFieldCell nextCell) {
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
  bool isCellReachable(GameFieldCell cell) {
    if (cell.isLand && !cell.hasRiver) {
      return false;
    }

    if (cell.nation == _startCell.nation! && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    if (_activeUnit.type == UnitType.carrier && cell.activeUnit != null && _startCell.nation != cell.nation) {
      return false;
    }

    return true;
  }
}
