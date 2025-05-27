/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of build_calculators;

sealed class BuildRestriction {}

class ProductionCenterBuildRestriction extends BuildRestriction {
  final ProductionCenterType productionCenterType;

  final ProductionCenterLevel productionCenterLevel;

  ProductionCenterBuildRestriction({required this.productionCenterType, required this.productionCenterLevel});
}

class AppropriateCell extends BuildRestriction { }

class AppropriateUnit extends BuildRestriction { }