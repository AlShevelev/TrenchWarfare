/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
  double? calculateGFactorHeuristic({
    required GameFieldCellRead priorCell,
    required GameFieldCellRead nextCell,
    required GameFieldCellRead lastCell,
  }) {
    if (nextCell == lastCell && isUnreachableEnemyCellReachableForArtilleryStrike(nextCell)) {
      return 1;
    }

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
  bool isCellReachable(GameFieldCellRead cell) {
    if (cell.isLand && !cell.hasRiver) {
      return false;
    }

    if (cell.nation == _startCell.nation && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    if (_unitType == UnitType.carrier && cell.activeUnit != null && _startCell.nation != cell.nation) {
      return false;
    }

    if (_metadata.isAlly(_myNation, cell.nation) &&
        (cell.units.isNotEmpty || cell.productionCenter != null)) {
      return false;
    }

    return true;
  }

  static bool canContainSeaUnit(GameFieldCellRead cell) => !(cell.isLand && !cell.hasRiver);

  @override
  bool isUnreachableEnemyCellReachableForArtilleryStrike(GameFieldCellRead nextCell) {
    if (nextCell.nation == _startCell.nation || _metadata.isAlly(_myNation, nextCell.nation)) {
      return false; // Not an enemy cell
    }

    if (nextCell.activeUnit == null) {
      return false; // No unit to attack
    }

    if (!_unit.hasArtillery) {
      return false; // Our unit doesn't have artillery
    }

    return !isCellReachable(nextCell);
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
