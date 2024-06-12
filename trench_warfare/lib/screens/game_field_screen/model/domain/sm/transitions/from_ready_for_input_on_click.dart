part of game_field_sm;

class FromReadyForInputOnClick extends GameObjectTransitionBase {
  FromReadyForInputOnClick(super.context);

  State process(GameFieldCell cell) {
    final unit = cell.activeUnit;

    final armyInfo = cell.nation == _context.nation && cell.units.length > 1
        ? GameFieldControlsArmyInfo(
            cellId: cell.id,
            units: cell.units.toList(growable: true),
          )
        : null;

    final carrierInfo = cell.nation == _context.nation &&
            unit != null &&
            unit.type == UnitType.carrier &&
            (unit as Carrier).hasUnits
        ? CarrierPanelCalculator.calculatePanel(unit, cell)
        : null;

    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: armyInfo,
      carrierInfo: carrierInfo,
    ));

    if (cell.nation != _context.nation) {
      return ReadyForInput();
    }

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);
    _context.updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);

    return WaitingForEndOfPath(cell);
  }
}
