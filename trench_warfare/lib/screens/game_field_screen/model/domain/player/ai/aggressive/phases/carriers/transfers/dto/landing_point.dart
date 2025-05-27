/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of carriers_phase_library;

class LandingPoint {
  final GameFieldCellRead carrierCell;

  final GameFieldCellRead unitsCell;

  LandingPoint({required this.carrierCell, required this.unitsCell});

  @override
  String toString() => 'LANDING POINT: {carrier: $carrierCell; units: $unitsCell}';
}