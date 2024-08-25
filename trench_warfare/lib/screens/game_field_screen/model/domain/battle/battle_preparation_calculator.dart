part of battle;

class UnitInBattlePreparationCalculator {
  late final Unit _attacking;
  late final GameFieldCell _defendingCell;

  Unit get _defending => _defendingCell.activeUnit!;

  UnitInBattlePreparationCalculator(Unit attacking, GameFieldCell defendingCell) {
    _attacking = attacking;
    _defendingCell = defendingCell;
  }

  UnitInBattle calculateAttackingUnit() {
    var base = _getBase(_attacking);

    base.updateAttack(_getTerrainAttackFactor(
      unitType: base.type,
      terrain: _defendingCell.terrain,
      hasProductionCenter: _defendingCell.productionCenter != null,
    ));

    base.updateDefence(_getTerrainDefenceFactor(
      unitType: base.type,
      terrain: _defendingCell.terrain,
      hasProductionCenter: _defendingCell.productionCenter != null,
    ));

    base.updateAttack(_getBoostAttackFactor(_attacking));

    base.updateDefence(_getBoostDefenceFactor(_attacking));

    base.updateDefence(_getProductionCenterDefenceFactor(_defendingCell.productionCenter));

    base = _updateAttackingByTerrainModifier(base, _defendingCell.terrainModifier?.type);

    base = _updateUnitByRival(base, _defending);

    return base;
  }

  UnitInBattle calculateDefendingUnit() {
    var base = _getBase(_defending);

    base.updateAttack(_getTerrainAttackFactor(
      unitType: base.type,
      terrain: _defendingCell.terrain,
      hasProductionCenter: _defendingCell.productionCenter != null,
    ));

    base.updateDefence(_getTerrainDefenceFactor(
      unitType: base.type,
      terrain: _defendingCell.terrain,
      hasProductionCenter: _defendingCell.productionCenter != null,
    ));

    base.updateAttack(_getBoostAttackFactor(_defending));

    base.updateDefence(_getBoostDefenceFactor(_defending));

    base.updateDefence(_getProductionCenterDefenceFactor(_defendingCell.productionCenter));

    base = _updateDefendingByTerrainModifier(base, _defendingCell.terrainModifier?.type);

    base = _updateUnitByRival(base, _attacking);

    return base;
  }

  UnitInBattle _getBase(Unit unit) => UnitInBattle(
        type: unit.type,
        damage: unit.damage,
        attack: unit.attack,
        defence: unit.defence,
        tookPartInBattles: unit.tookPartInBattles,
        fatigue: unit.fatigue,
        healthBeforeBattle: unit.health,
        health: unit.health,
        maxHealth: unit.maxHealth,
        isMechanical: unit.isMechanical,
        hasMachineGun: unit.hasMachineGun,
        hasArtillery: unit.hasArtillery,
      );

  double _getTerrainAttackFactor({required UnitType unitType, required CellTerrain terrain, required bool hasProductionCenter}) {
    if (hasProductionCenter) {
      return 1;
    }

    return switch (terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (unitType) {
          UnitType.infantry => 0.7,
          UnitType.machineGuns => 0.6,
          UnitType.cavalry => 0.4,
          UnitType.machineGunnersCart => 0.3,
          UnitType.artillery => 0.1,
          UnitType.armoredCar => 0.6,
          UnitType.tank => 0.6,
          _ => 0,
        },
      CellTerrain.marsh => switch (unitType) {
          UnitType.infantry => 0.8,
          UnitType.machineGuns => 0.7,
          UnitType.cavalry => 0.5,
          _ => 0,
        },
      CellTerrain.sand => switch (unitType) {
          UnitType.infantry => 0.9,
          UnitType.machineGuns => 0.9,
          UnitType.cavalry => 0.7,
          UnitType.machineGunnersCart => 0.7,
          UnitType.artillery => 1.2,
          UnitType.armoredCar => 1,
          UnitType.tank => 0.9,
          _ => 0,
        },
      CellTerrain.hills => switch (unitType) {
          UnitType.infantry => 0.8,
          UnitType.machineGuns => 0.8,
          UnitType.cavalry => 0.5,
          UnitType.machineGunnersCart => 0.6,
          UnitType.artillery => 1.2,
          UnitType.armoredCar => 0.7,
          UnitType.tank => 0.7,
          _ => 0,
        },
      CellTerrain.mountains => switch (unitType) {
          UnitType.infantry => 0.5,
          _ => 0,
        },
      CellTerrain.snow => switch (unitType) {
          UnitType.infantry => 0.6,
          UnitType.machineGuns => 0.9,
          UnitType.cavalry => 0.6,
          UnitType.machineGunnersCart => 0.7,
          UnitType.artillery => 1.2,
          UnitType.armoredCar => 0.8,
          UnitType.tank => 0.8,
          _ => 0,
        },
      CellTerrain.water => 1,
    };
  }

  double _getTerrainDefenceFactor({required UnitType unitType, required CellTerrain terrain, required bool hasProductionCenter}) {
    if (hasProductionCenter) {
      return 1;
    }

    return switch (terrain) {
      CellTerrain.plain => 1,
      CellTerrain.wood => switch (unitType) {
          UnitType.infantry => 1.2,
          UnitType.machineGuns => 0.5,
          UnitType.cavalry => 0.5,
          UnitType.machineGunnersCart => 0.5,
          UnitType.artillery => 0.1,
          UnitType.armoredCar => 0.6,
          UnitType.tank => 0.5,
          _ => 0,
        },
      CellTerrain.marsh => switch (unitType) {
          UnitType.infantry => 0.8,
          UnitType.machineGuns => 0.8,
          UnitType.cavalry => 0.6,
          _ => 0,
        },
      CellTerrain.sand => switch (unitType) {
          UnitType.infantry => 0.9,
          UnitType.machineGuns => 1,
          UnitType.cavalry => 0.9,
          UnitType.machineGunnersCart => 0.9,
          UnitType.artillery => 1,
          UnitType.armoredCar => 0.9,
          UnitType.tank => 1,
          _ => 0,
        },
      CellTerrain.hills => switch (unitType) {
          UnitType.infantry => 1.2,
          UnitType.machineGuns => 1.2,
          UnitType.cavalry => 0.8,
          UnitType.machineGunnersCart => 0.8,
          UnitType.artillery => 1,
          UnitType.armoredCar => 1,
          UnitType.tank => 1,
          _ => 0,
        },
      CellTerrain.mountains => switch (unitType) {
          UnitType.infantry => 0.9,
          _ => 0,
        },
      CellTerrain.snow => switch (unitType) {
          UnitType.infantry => 0.9,
          UnitType.machineGuns => 1,
          UnitType.cavalry => 0.9,
          UnitType.machineGunnersCart => 0.9,
          UnitType.artillery => 1,
          UnitType.armoredCar => 0.9,
          UnitType.tank => 1,
          _ => 0,
        },
      CellTerrain.water => 1,
    };
  }

  double _getBoostAttackFactor(Unit unit) {
    var base = 1.0;

    if (unit.hasBoost(UnitBoost.attack)) {
      base *= 1.2;
    }

    if (unit.hasBoost(UnitBoost.commander)) {
      base *= 1.4;
    }

    return base;
  }

  double _getBoostDefenceFactor(Unit unit) {
    var base = 1.0;

    if (unit.hasBoost(UnitBoost.defence)) {
      base *= 1.2;
    }

    if (unit.hasBoost(UnitBoost.commander)) {
      base *= 1.4;
    }

    return base;
  }

  double _getProductionCenterDefenceFactor(ProductionCenter? productionCenter) {
    if (productionCenter == null) {
      return 1;
    }

    return switch (productionCenter.type) {
      ProductionCenterType.city => switch (productionCenter.level) {
          ProductionCenterLevel.level1 => 1.15,
          ProductionCenterLevel.level2 => 1.3,
          ProductionCenterLevel.level3 => 1.45,
          ProductionCenterLevel.level4 => 1.6,
          ProductionCenterLevel.capital => 1.75,
        },
      ProductionCenterType.factory => switch (productionCenter.level) {
          ProductionCenterLevel.level1 => 1.2,
          ProductionCenterLevel.level2 => 1.4,
          ProductionCenterLevel.level3 => 1.6,
          ProductionCenterLevel.level4 => 1.8,
          _ => 1,
        },
      _ => 1,
    };
  }

  UnitInBattle _updateAttackingByTerrainModifier(UnitInBattle attacking, TerrainModifierType? terrainModifier) {
    if (terrainModifier == TerrainModifierType.barbedWire) {
      if (attacking.type != UnitType.tank && attacking.type != UnitType.artillery) {
        attacking.updateAttack(0.8);
      }
    }

    return attacking;
  }

  UnitInBattle _updateDefendingByTerrainModifier(UnitInBattle defending, TerrainModifierType? terrainModifier) {
    if (terrainModifier == TerrainModifierType.trench) {
      if (defending.type == UnitType.infantry || defending.type == UnitType.machineGuns) {
        defending.updateDefence(1.2);
      }
    }

    if (terrainModifier == TerrainModifierType.landFort) {
      defending.updateAttack(1.2);
      defending.updateDefence(1.2);
      defending.updateHasArtillery(true);
      defending.updateHasMachineGun(true);
      defending.increaseHealth(defending.health);
    }

    return defending;
  }

  /// Must be called twice
  UnitInBattle _updateUnitByRival(UnitInBattle unit, Unit rivalUnit) {
    if (unit.hasMachineGun && !rivalUnit.isMechanical) {
      unit.updateAttack(1.5);
    }

    return unit;
  }
}
