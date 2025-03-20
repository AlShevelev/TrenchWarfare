part of pathfinding;

class LandFindPathSettings implements FindPathSettings {
  final GameFieldCellRead _startCell;

  final Unit _unit;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  UnitType get _unitType => _unit.type;

  LandFindPathSettings({
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

    // Can't move from a carrier to a carrier
    if (priorCell.activeUnit is Carrier && nextCell.activeUnit is Carrier && priorCell.id != nextCell.id) {
      //if (_isCellReachableCarrier(priorCell) && _isCellReachableCarrier(nextCell)) {
      return null;
      //}
    }

    if (nextCell.activeUnit is Carrier) {
      return 1;
    }

    // Try to avoid mine fields
    final terrainModifier = nextCell.terrainModifier?.type;
    if (terrainModifier == TerrainModifierType.landMine) {
      return _getMineFactor();
    }

    // Try to avoid trenches
    final nextCellIsEnemy = nextCell.nation != null && nextCell.nation != _startCell.nation;
    if (nextCellIsEnemy && terrainModifier == TerrainModifierType.trench) {
      return 8;
    }

    // Try to avoid barbed wire
    if (nextCellIsEnemy && terrainModifier == TerrainModifierType.barbedWire && _unitType != UnitType.tank) {
      return 8;
    }

    // Try to avoid enemy formations
    if (nextCellIsEnemy && nextCell.units.isNotEmpty) {
      return 8;
    }

    // Try to use roads (must be checked before rivers to use bridges)
    if (nextCell.hasRoad) {
      return 1;
    }

    // Try to avoid rivers
    if (nextCell.hasRiver) {
      return 8;
    }

    // Production centers
    final productionCenter = nextCell.productionCenter?.type;
    if (productionCenter == ProductionCenterType.factory || productionCenter == ProductionCenterType.city) {
      return 1;
    }

    return _calculateForTerrain(nextCell);
  }

  @override
  bool isCellReachable(GameFieldCellRead cell) => LandFindPathSettings.isCellReachableStatic(
        _unitType,
        _myNation,
        _metadata,
        startCell: _startCell,
        cell: cell,
      );

  static bool isCellReachableStatic(
    UnitType unit,
    Nation myNation,
    MapMetadataRead metadata, {
    required GameFieldCellRead startCell,
    required GameFieldCellRead cell,
  }) {
    if (metadata.isAlly(myNation, cell.nation) && (cell.units.isNotEmpty || cell.productionCenter != null)) {
      return false;
    }

    if (cell.activeUnit is Carrier) {
      return _isCellReachableCarrier(cell: cell, startCell: startCell);
    } else {
      return _isCellReachableLand(unit, startCell: startCell, cell: cell);
    }
  }

  static bool _isCellReachableLand(
    UnitType unit, {
    required GameFieldCellRead startCell,
    required GameFieldCellRead cell,
  }) {
    if (!cell.isLand) {
      return false;
    }

    if (cell.nation == startCell.nation! && cell.units.length == GameConstants.maxUnitsInCell) {
      return false;
    }

    //terrain type
    final terrain = cell.terrain;

    if (terrain == CellTerrain.marsh &&
        (unit == UnitType.machineGunnersCart ||
            unit == UnitType.artillery ||
            unit == UnitType.armoredCar ||
            unit == UnitType.tank)) {
      return false;
    }

    if (terrain == CellTerrain.mountains &&
        (unit == UnitType.machineGuns ||
            unit == UnitType.cavalry ||
            unit == UnitType.machineGunnersCart ||
            unit == UnitType.artillery ||
            unit == UnitType.armoredCar ||
            unit == UnitType.tank)) {
      return false;
    }

    return true;
  }

  static bool _isCellReachableCarrier({
    required GameFieldCellRead startCell,
    required GameFieldCellRead cell,
  }) {
    final carrier = cell.activeUnit as Carrier;

    if (cell.nation != startCell.nation!) {
      return false;
    }

    return carrier.hasPlaceForUnit;
  }

  double? _calculateForTerrain(GameFieldCellRead nextCell) {
    return switch (nextCell.terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (_unitType) {
          UnitType.infantry => 1.25,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 2,
          UnitType.artillery => 2,
          UnitType.armoredCar => 2,
          UnitType.tank => 2,
          _ => null,
        },
      CellTerrain.marsh => switch (_unitType) {
          UnitType.infantry => 2,
          UnitType.machineGuns => 2,
          UnitType.cavalry => 2,
          _ => null,
        },
      CellTerrain.sand => switch (_unitType) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.4,
          UnitType.machineGunnersCart => 1.7,
          UnitType.artillery => 2,
          UnitType.armoredCar => 1.7,
          UnitType.tank => 1.25,
          _ => null,
        },
      CellTerrain.hills => switch (_unitType) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => null,
        },
      CellTerrain.mountains => switch (_unitType) { UnitType.infantry => 2, _ => null },
      CellTerrain.snow => switch (_unitType) {
          UnitType.infantry => 1.4,
          UnitType.machineGuns => 1.7,
          UnitType.cavalry => 1.25,
          UnitType.machineGunnersCart => 1.25,
          UnitType.artillery => 1.7,
          UnitType.armoredCar => 1.25,
          UnitType.tank => 1.25,
          _ => null,
        },
      _ => null,
    };
  }

  double _getMineFactor() {
    const minValue = 1.0;
    const maxValue = 8.0;

    final factor = UnitPowerEstimation.estimate(_unit) * maxValue / UnitPowerEstimation.maxLandPower;

    if (factor < minValue) {
      return minValue;
    }

    if (factor > maxValue) {
      return maxValue;
    }

    return factor;
  }
}
