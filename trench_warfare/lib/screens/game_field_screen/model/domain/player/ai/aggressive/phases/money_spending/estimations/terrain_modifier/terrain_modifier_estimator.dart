/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of money_spending_phase_library;

class _TerrainModifierEstimationData implements EstimationData {
  @override
  final GameFieldCellRead cell;

  final TerrainModifierType type;

  _TerrainModifierEstimationData({required this.cell, required this.type});
}
