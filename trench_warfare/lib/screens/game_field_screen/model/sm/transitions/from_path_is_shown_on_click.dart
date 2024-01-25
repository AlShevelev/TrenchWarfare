part of game_field_sm;

class FromPathIsShownOnClick extends TransitionBase {
  FromPathIsShownOnClick(super.updateGameObjectsEvent, super.gameField);

  State process(Iterable<GameFieldCell> path, GameFieldCell cell) {
    final firstCell = path.first;

    final unit = firstCell.activeUnit!;

    /// Clear the old path
    void resetPath() {
      for (var pathCell in path) {
        pathCell.setPathItem(null);
      }
      _updateGameObjectsEvent.update(path.map((c) => UpdateObject(c)));
    }

    /// Clear the path and make the unit enabled
    State resetPathAndEnableUnit() {
      unit.setState(UnitState.enabled);
      resetPath();
      return ReadyForInput();
    }

    if (cell == path.first) {
      return resetPathAndEnableUnit();
    }

    // calculate a path
    Iterable<GameFieldCell> newPath = _calculatePath(startCell: firstCell, endCell: cell, isLandUnit: unit.isLand);

    if (newPath.isEmpty) {
      return resetPathAndEnableUnit();
    }

    resetPath();

    // show the new path
    final estimatedPath = _estimatePath(path: newPath, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(newPath);
  }
}