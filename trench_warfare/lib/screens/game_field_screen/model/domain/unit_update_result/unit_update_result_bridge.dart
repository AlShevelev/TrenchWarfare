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

abstract interface class UnitUpdateResultBridgeRead {
  List<UnitUpdateResultItem> extractResult();
}

abstract interface class UnitUpdateResultBridge {
  void addBefore({
    required Nation nation,
    required Unit unit,
    required GameFieldCellRead cell,
  });

  void addAfter({
    required Nation nation,
    required Unit unit,
    required GameFieldCellRead cell,
  });
}

/// Passes a movement result between components
class UnitUpdateResultBridgeImpl implements UnitUpdateResultBridge, UnitUpdateResultBridgeRead {
  final List<UnitUpdateResultItem> _result = [];

  @override
  void addBefore({
    required Nation nation,
    required Unit unit,
    required GameFieldCellRead cell,
  }) {
    _result.add(UnitUpdateResultItem(
      nation: nation,
      type: UnitUpdateResulType.before,
      unit: unit,
      cell: cell,
    ));
  }

  @override
  void addAfter({
    required Nation nation,
    required Unit unit,
    required GameFieldCellRead cell,
  }) {
    _result.add(UnitUpdateResultItem(
      nation: nation,
      type: UnitUpdateResulType.after,
      unit: unit,
      cell: cell,
    ));
  }

  @override
  List<UnitUpdateResultItem> extractResult() {
    final result = _result.toList(growable: false);
    _result.clear();
    return result;
  }
}
