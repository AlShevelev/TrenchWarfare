part of game_field_sm;

class FromWaitingForEndOfPathOnResortUnit extends GameObjectTransitionBase {
  FromWaitingForEndOfPathOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
  );

  State process(String cellId, Iterable<String> unitsId) {
    final cell = _gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;
    if (activeUnit != null && activeUnit.state == UnitState.active) {
      activeUnit.setState(UnitState.enabled);
    }

    cell.resortUnits(unitsId);

    _updateGameObjectsEvent.update([UpdateObject(cell)]);

    return ReadyForInput();
  }
}
