part of build_calculators;

sealed class BuildRestriction {}

class UnitBuildRestriction extends BuildRestriction {
  final ProductionCenterType productionCenterType;

  final ProductionCenterLevel productionCenterLevel;

  UnitBuildRestriction({required this.productionCenterType, required this.productionCenterLevel});
}

class AppropriateCell extends BuildRestriction { }