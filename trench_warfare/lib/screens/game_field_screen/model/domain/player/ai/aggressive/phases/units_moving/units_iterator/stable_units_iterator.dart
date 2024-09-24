part of units_moving_phase_library;

/// Interacts through my units, taking into account their removing, resorting etc.
class StableUnitsIterator implements Iterator<UnitOnCell> {
  late final List<GameFieldCellRead> _gameFieldCells;

  var _currentCellIndex = -1;

  List<String> _unitIdsInTheCurrentCell = [];

  final List<Unit> _excludedUnits;

  var _currentUnitIndex = -1;

  /// A unit can be removed (destroyed in a battle) or resorted.
  /// So, we must find it by its Id, and not by an index in the cell.units list
  @override
  UnitOnCell get current {
    final cell = _gameFieldCells[_currentCellIndex];
    final unit = cell.units.singleWhere((u) => u.id == _unitIdsInTheCurrentCell[_currentUnitIndex]);

    return UnitOnCell(cell: cell, unit: unit);
  }

  StableUnitsIterator({
    required GameFieldRead gameField,
    required Nation myNation,
    required List<Unit> excludedUnits,
    bool shifted = true,
  }) : _excludedUnits = excludedUnits {
    _gameFieldCells = List<GameFieldCellRead>.from(
      gameField.cells.where((c) => c.nation == myNation && c.units.isNotEmpty),
      growable: false,
    );

    if (shifted) {
      _shiftCells();
    }
  }

  StableUnitsIterator.fromCell(List<GameFieldCellRead> cells, {bool shifted = true}) : _excludedUnits = [] {
    _gameFieldCells = cells;

    if (shifted) {
      _shiftCells();
    }
  }

  @override
  bool moveNext() {
    if (_gameFieldCells.isEmpty) {
      return false;
    }

    if (_currentUnitIndex == _unitIdsInTheCurrentCell.length - 1) {
      if (_currentCellIndex == _gameFieldCells.length - 1) {
        return false;
      }

      _currentCellIndex++;
      _unitIdsInTheCurrentCell =
          _gameFieldCells[_currentCellIndex].units.map((u) => u.id).toList(growable: false);
      _currentUnitIndex = 0;

      return _excludedUnits.contains(current.unit) ? moveNext() : true;
    }

    _currentUnitIndex++;

    return _excludedUnits.contains(current.unit) ? moveNext() : true;
  }

  void _shiftCells() => RandomGen.shiftItems(_gameFieldCells);
}
