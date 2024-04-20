part of build_calculators;

sealed class BuildRestriction {}

class ProductionCenterBuildRestriction extends BuildRestriction {
  final ProductionCenterType productionCenterType;

  final ProductionCenterLevel productionCenterLevel;

  ProductionCenterBuildRestriction({required this.productionCenterType, required this.productionCenterLevel});
}

class AppropriateCell extends BuildRestriction { }

class AppropriateUnit extends BuildRestriction { }