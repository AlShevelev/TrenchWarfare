part of game_field_sm;

class FromReadyForInputOnClick {
  final GameFieldStateMachineContext _context;

  FromReadyForInputOnClick(this._context);

  State process(GameFieldCell cell) {
    final unit = cell.activeUnit;

    if (cell.nation != _context.myNation) {
      return ReadyForInput();
    }

    if (unit == null || unit.state != UnitState.enabled) {
      return ReadyForInput();
    }

    unit.setState(UnitState.active);

    if (!_context.isAI) {
      final events = <UpdateGameEvent>[];

      events.add(PlaySound(type: SoundType.buttonClick));
      events.add(UpdateCell(cell, updateBorderCells: []));

      _context.updateGameObjectsEvent.update(events);
    }

    final armyInfo = cell.nation == _context.myNation && cell.units.length > 1
        ? GameFieldControlsArmyInfo(
      cellId: cell.id,
      units: cell.units.toList(growable: true),
      nation: _context.myNation,
    )
        : null;

    final carrierInfo = cell.nation == _context.myNation &&
        unit.type == UnitType.carrier &&
        (unit as Carrier).hasUnits
        ? CarrierPanelCalculator.calculatePanel(unit, cell)
        : null;

    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: null,
        armyInfo: armyInfo,
        carrierInfo: carrierInfo,
        nation: _context.myNation,
        showDismissButton: true,
      ),
    );

    return WaitingForEndOfPath(cell);
  }
}
