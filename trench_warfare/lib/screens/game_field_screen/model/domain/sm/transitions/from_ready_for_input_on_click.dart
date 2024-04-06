part of game_field_sm;

class FromReadyForInputOnClick extends GameObjectTransitionBase {
  late final Nation _nation;

  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nation,
    this._nationMoney,
    this._controlsState,
  );

  State process(GameFieldCell cell) {
    final unit = cell.activeUnit;

    if (cell.nation == _nation && cell.units.length > 1) {
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: GameFieldControlsArmyInfo(
          cellId: cell.id,
          units: cell.units.toList(growable: true),
        ),
      ));
    } else {
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: null,
      ));
    }

    if (cell.nation != _nation) {
      return ReadyForInput();
    }

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);
    _updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);

    return WaitingForEndOfPath(cell);
  }
}
