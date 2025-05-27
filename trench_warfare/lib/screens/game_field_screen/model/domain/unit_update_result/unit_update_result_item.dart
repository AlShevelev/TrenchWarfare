/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of unit_udpate_result;

enum UnitUpdateResulType {
  before,
  after,
}

class UnitUpdateResultItem {
  final Nation nation;

  final Unit unit;

  final GameFieldCellRead cell;

  final UnitUpdateResulType type;

  UnitUpdateResultItem({
    required this.nation,
    required this.unit,
    required this.cell,
    required this.type,
  });

  @override
  String toString() => 'MOVEMENT_RESULT_ITEM: { unit: ${unit.toStringBrief()}; cell: ${cell.toStringBrief()}; nation: $nation; type: $type';
}
