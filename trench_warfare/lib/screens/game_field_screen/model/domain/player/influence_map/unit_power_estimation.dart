part of  influence_map;

class UnitPowerEstimation {
  static double estimate(Unit unit) {
    if (unit is Carrier) {
      return _estimateCarrier(unit);
    } else {
      return _estimateUnit(unit);
    }
  }

  static double _estimateCarrier(Carrier carrier) =>
      carrier.hasUnits ? carrier.units.map((u) => _estimateUnit(u)).sum() : 1;

  static double _estimateUnit(Unit unit) {
    final boostFactor = 0.05 * unit.maxHealth;

    var result = unit.health;

    result += unit.attack * boostFactor;
    result += unit.defence * boostFactor;
    result += boostFactor * (unit.damage.min + unit.damage.max) /  2;

    if (unit.hasBoost(UnitBoost.attack)) {
      result += boostFactor;
    }

    if (unit.hasBoost(UnitBoost.defence)) {
      result += boostFactor;
    }

    if (unit.hasBoost(UnitBoost.commander)) {
      result += boostFactor;
    }

    result += boostFactor * switch(unit.experienceRank) {
      UnitExperienceRank.rookies => 0,
      UnitExperienceRank.fighters => 0.5,
      UnitExperienceRank.proficients => 1,
      UnitExperienceRank.veterans => 1.5,
      UnitExperienceRank.elite => 2,
    };

    return result;
  }
}