part of movement;

abstract interface class MovementResultBridgeRead {
  List<MovementResultItem> extractResult();
}

abstract interface class MovementResultBridge {
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
class MovementResultBridgeImpl implements MovementResultBridge, MovementResultBridgeRead {
  final List<MovementResultItem> _result = [];

  @override
  void addBefore({
    required Nation nation,
    required Unit unit,
    required GameFieldCellRead cell,
  }) {
    _result.add(MovementResultItem(
      nation: nation,
      type: MovementResulType.before,
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
    _result.add(MovementResultItem(
      nation: nation,
      type: MovementResulType.after,
      unit: unit,
      cell: cell,
    ));
  }

  @override
  List<MovementResultItem> extractResult() {
    final result = _result.toList(growable: false);
    _result.clear();
    return result;
  }
}
