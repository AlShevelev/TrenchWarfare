part of units_moving_phase_library;

/// Interacts through my units, taking into account their removing, resorting etc.
class StableUnitsIterator implements Iterator<_UnitOnCell> {
  late final List<GameFieldCellRead> _gameFieldCells;

  var _currentCellIndex = -1;

  List<String> _unitIdsInTheCurrentCell = [];

  var _currentUnitIndex = -1;

  StableUnitsIterator({
    required GameFieldRead gameField,
    required Nation myNation,
    bool shifted = true,
  }) {
    _gameFieldCells = List<GameFieldCellRead>.from(
      gameField.cells.where((c) => c.nation == myNation && c.units.isNotEmpty),
      growable: false,
    );

    if (_gameFieldCells.length > 2 && shifted) {
      for (var i = 0; i < _gameFieldCells.length; i++) {
        final index1 = RandomGen.randomInt(_gameFieldCells.length);
        final index2 = RandomGen.randomInt(_gameFieldCells.length);

        final a = _gameFieldCells[index1];
        _gameFieldCells[index1] = _gameFieldCells[index2];
        _gameFieldCells[index2] = a;
      }
    }
  }

  /// A unit can be removed (destroyed in a battle) or resorted.
  /// So, we must find it by its Id, and not by an index in the cell.units list
  @override
  _UnitOnCell get current {
    final cell = _gameFieldCells[_currentCellIndex];
    final unit = cell
        .units
        .singleWhere((u) => u.id == _unitIdsInTheCurrentCell[_currentUnitIndex]);

    return _UnitOnCell(cell: cell, unit: unit);
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

      return true;
    }

    _currentUnitIndex++;

    return true;
  }
}
