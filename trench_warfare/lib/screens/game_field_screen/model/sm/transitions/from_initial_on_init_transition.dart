part of game_field_sm;

class FromInitialOnInitTransition extends TransitionBase {
  FromInitialOnInitTransition(super.updateGameObjectsEvent, super.gameField);

  State process() {
    final cellsToAdd = _gameField.cells.where((c) => !c.isEmpty);
    _updateGameObjectsEvent.update(cellsToAdd.map((c) => UpdateObject(c)));

    return ReadyForInput();
  }
}
