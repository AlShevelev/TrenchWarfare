part of pathfinding;

class SeaFindPathSettings implements FindPathSettings {
  final GameFieldCellRead _startCell;

  final Unit _unit;

  UnitType get _unitType => _unit.type;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  SeaFindPathSettings({
    required GameFieldCellRead startCell,
    required Unit calculatedUnit,
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _startCell = startCell,
        _unit = calculatedUnit,
        _myNation = myNation,
        _metadata = metadata;

  @override
  double? calculateGFactorHeuristic(GameFieldCellRead priorCell, GameFieldCellRead nextCell) {
    if (!isCellReachable(nextCell)) {
      return null;
    }

    // Try to avoid mine fields
    if (nextCell.terrainModifier?.type == TerrainModifierType.seaMine) {
      return _getMineFactor();
    }

    // Try to avoid enemy formations
    if (nextCell.nation != null && nextCell.nation != _startCell.nation && _startCell.units.isNotEmpty) {
      return 8;
    }

    return 1;
  }

  @override
  bool isCellReachable(GameFieldCellRead cell) => SeaFindPathSettings.isCellReachableStatic(
        _unitType,
        _myNation,
        _metadata,
        cell: cell,
        startCell: _startCell,
      );

  static bool canContainSeaUnit(GameFieldCellRead cell) => !(cell.isLand && !cell.hasRiver);

  static bool isCellReachableStatic(
    UnitType calculatedUnitType,
    Nation myNation,
    MapMetadataRead metadata, {
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

    if (metadata.isAlly(myNation, cell.nation) && (cell.units.isNotEmpty || cell.productionCenter != null)) {
      return false;
    }

    return true;
  }

  double _getMineFactor() {
    const minValue = 1.0;
    const maxValue = 8.0;

    final factor = UnitPowerEstimation.estimate(_unit) * maxValue / UnitPowerEstimation.maxSeaPower;

    if (factor < minValue) {
      return minValue;
    }

    if (factor > maxValue) {
      return maxValue;
    }

    return factor;
  }
}
