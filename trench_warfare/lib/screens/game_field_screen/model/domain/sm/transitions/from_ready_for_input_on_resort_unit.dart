part of game_field_sm;

class FromReadyForInputOnResortUnit extends GameObjectTransitionBase {
  FromReadyForInputOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
  );

  State process(String cellId, Iterable<String> unitsId) {
    final cell = _gameField.getCellById(cellId);

    cell.resortUnits(unitsId);

    _updateGameObjectsEvent.update([UpdateObject(cell)]);

    return ReadyForInput();
  }
}
