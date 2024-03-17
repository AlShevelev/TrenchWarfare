part of game_field_sm;

class FromReadyForInputOnClick extends GameObjectTransitionBase {
  late final NationRecord _nationRecord;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    NationRecord nationRecord,
    SingleStream<GameFieldControlsState> controlsState
  ) {
    _nationRecord = nationRecord;
    _controlsState = controlsState;
  }

  State process(GameFieldCell cell) {
    final unit = cell.activeUnit;

    if (cell.nation == _nationRecord.code && cell.units.length > 1) {
      _controlsState.update(Visible(
        money: _nationRecord.startMoney,
        industryPoints: _nationRecord.startIndustryPoints,
        cellInfo: null,
        armyInfo: GameFieldControlsArmyInfo(
          cellId: cell.id,
          units: cell.units.toList(growable: false),
        ),
      ));
    } else {
      _controlsState.update(Visible(
        money: _nationRecord.startMoney,
        industryPoints: _nationRecord.startIndustryPoints,
        cellInfo: null,
        armyInfo: null,
      ));
    }

    if (cell.nation != _nationRecord.code) {
      return ReadyForInput();
    }

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);
    _updateGameObjectsEvent.update([UpdateObject(cell)]);

    return WaitingForEndOfPath(cell);
  }
}
