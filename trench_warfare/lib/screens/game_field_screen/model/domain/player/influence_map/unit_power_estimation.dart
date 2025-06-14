/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of influence_map;

class UnitPowerEstimation {
  static final maxLandPower = _estimateUnit(_getMostPowerfulLandUnit());

  static final maxSeaPower = _estimateUnit(_getMostPowerfulSeaUnit());

  static double estimate(Unit unit) {
    if (unit is Carrier) {
      return _estimateCarrier(unit);
    } else {
      return _estimateUnit(unit);
    }
  }

  static double _estimateCarrier(Carrier carrier) =>
      carrier.hasUnits ? carrier.units.map((u) => _estimateUnit(u)).sum : 1;

  static double _estimateUnit(Unit unit) {
    final boostFactor = 0.05 * unit.maxHealth;

    var result = unit.health;

    result += unit.attack * boostFactor;
    result += unit.defence * boostFactor;
    result += boostFactor * (unit.damage.min + unit.damage.max) / 2;

    if (unit.hasBoost(UnitBoost.attack)) {
      result += boostFactor;
    }

    if (unit.hasBoost(UnitBoost.defence)) {
      result += boostFactor;
    }

    if (unit.hasBoost(UnitBoost.commander)) {
      result += boostFactor;
    }

    if (unit.hasArtillery) {
      result += boostFactor;
    }

    if (unit.hasMachineGun) {
      result += boostFactor;
    }

    result += boostFactor *
        switch (unit.experienceRank) {
          UnitExperienceRank.rookies => 0,
          UnitExperienceRank.fighters => 0.5,
          UnitExperienceRank.proficients => 1,
          UnitExperienceRank.veterans => 1.5,
          UnitExperienceRank.elite => 2,
        };

    return result;
  }

  static Unit _getMostPowerfulLandUnit() => Unit(
      boost1: UnitBoost.attack,
      boost2: UnitBoost.defence,
      boost3: UnitBoost.commander,
      experienceRank: UnitExperienceRank.elite,
      fatigue: 1.0,
      health: 1.0,
      movementPoints: 1.0,
      type: UnitType.tank,
    );

  static Unit _getMostPowerfulSeaUnit() => Unit(
    boost1: UnitBoost.attack,
    boost2: UnitBoost.defence,
    boost3: UnitBoost.commander,
    experienceRank: UnitExperienceRank.elite,
    fatigue: 1.0,
    health: 1.0,
    movementPoints: 1.0,
    type: UnitType.battleship,
  );
}
