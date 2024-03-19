part of game_field_sm;

class FromPathIsShownOnResortUnit extends GameObjectTransitionBase {
  FromPathIsShownOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
  );

  State process(Iterable<GameFieldCell> path, String cellId, Iterable<String> unitsId) {
    final cell = _gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;
    if (activeUnit != null && activeUnit.state == UnitState.active) {
      activeUnit.setState(UnitState.enabled);
    }

    cell.resortUnits(unitsId);

    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _updateGameObjectsEvent.update(path.map((c) => UpdateObject(c)));

    return ReadyForInput();
  }
}
