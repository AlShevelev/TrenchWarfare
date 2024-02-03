part of game_field_sm;

class FromPathIsShownOnClick extends TransitionBase {
  late final Nation _nation;

  FromPathIsShownOnClick(super.updateGameObjectsEvent, super.gameField, Nation nation) {
    _nation = nation;
  }

  State process(Iterable<GameFieldCell> path, GameFieldCell cell) {
    final firstCell = path.first;

    final unit = firstCell.activeUnit!;

    if (cell == path.first) {
      return _resetPathAndEnableUnit(path, unit);
    }

    if (cell == path.last) {
      return MovementFacade(
        nation: _nation,
        gameField: _gameField,
        updateGameObjectsEvent: _updateGameObjectsEvent,
      ).startMovement(path);
    }

    // calculate a path
    Iterable<GameFieldCell> newPath = _calculatePath(startCell: firstCell, endCell: cell, isLandUnit: unit.isLand);

    if (newPath.isEmpty) {
      return _resetPathAndEnableUnit(path, unit);
    }

    _resetPath(path);

    // show the new path
    final estimatedPath = _estimatePath(path: newPath, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(newPath);
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _updateGameObjectsEvent.update(path.map((c) => UpdateObject(c)));
  }

  /// Clear the path and make the unit enabled
  State _resetPathAndEnableUnit(Iterable<GameFieldCell> path, Unit unit) {
    unit.setState(UnitState.enabled);
    _resetPath(path);
    return ReadyForInput();
  }
}
