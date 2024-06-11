part of game_field_sm;

class FromReadyForInputOnClick extends GameObjectTransitionBase {
  late final Nation _nation;

  late final MoneyUnit _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nation,
    this._nationMoney,
    this._controlsState,
  );

  State process(GameFieldCell cell) {
    final unit = cell.activeUnit;

    final armyInfo = cell.nation == _nation && cell.units.length > 1
        ? GameFieldControlsArmyInfo(
            cellId: cell.id,
            units: cell.units.toList(growable: true),
          )
        : null;

    final carrierInfo = cell.nation == _nation &&
            unit != null &&
            unit.type == UnitType.carrier &&
            (unit as Carrier).hasUnits
        ? CarrierPanelCalculator.calculatePanel(unit, cell)
        : null;

    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: armyInfo,
      carrierInfo: carrierInfo,
    ));

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
