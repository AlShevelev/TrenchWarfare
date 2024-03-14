part of game_field_sm;

class FromWaitingForEndOfPathOnClick extends GameObjectTransitionBase {
  FromWaitingForEndOfPathOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
  );

  State process(GameFieldCell startCell, GameFieldCell endCell) {
    final unit = startCell.activeUnit!;

    if (startCell == endCell) {
      // reset the unit active state
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateObject(startCell)]);
      return ReadyForInput();
    }

    // calculate a path
    Iterable<GameFieldCell> path = _calculatePath(startCell: startCell, endCell: endCell, isLandUnit: unit.isLand);

    if (path.isEmpty) {
      // reset the unit active state
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateObject(startCell)]);
      return ReadyForInput();
    }

    final estimatedPath = _estimatePath(path: path, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateObject(c)));

    return PathIsShown(estimatedPath);
  }
}
