part of game_field_sm;

class FromReadyForInputOnClick extends TransitionBase {
  late final Nation _nation;

  FromReadyForInputOnClick(super.updateGameObjectsEvent, super.gameField, Nation nation) {
    _nation = nation;
  }

  State process(GameFieldCell cell) {
    if (cell.nation != _nation) {
      return ReadyForInput();
    }

    final unit = cell.activeUnit;

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);
    _updateGameObjectsEvent.update([UpdateObject(cell)]);

    return WaitingForEndOfPath(cell);
  }
}