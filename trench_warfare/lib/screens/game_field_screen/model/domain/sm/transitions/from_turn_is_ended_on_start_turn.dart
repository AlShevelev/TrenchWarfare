part of game_field_sm;

class FromTurnIsEndedOnStartTurn extends GameObjectTransitionBase {
  static const partOfHealthRestoredWithoutProductionCenter = 0.2;
  static const partOfHealthRestoredWithProductionCenter = 0.4;

  FromTurnIsEndedOnStartTurn(super.context);

  State process() {
    _context.money.recalculate();

    final List<UpdateGameEvent> events = [];

    for (var cell in _context.gameField.cells) {
      if (cell.nation != _context.nation || cell.units.isEmpty) {
        continue;
      }

      for (var unit in cell.units) {
        updateUnit(unit, cell.productionCenter?.type);

        if (unit is Carrier) {
          for (var unit in unit.units) {
            updateUnit(unit, null);
          }
        }
      }

      events.add(UpdateCell(cell, updateBorderCells: []));
    }

    final cameraPosition = _context.gameFieldSettingsStorage.cameraPosition;
    events.add(SetCamera(
      _context.gameFieldSettingsStorage.zoom ?? ZoomConstants.startZoom,
      cameraPosition,
    ));
    if (cameraPosition == null) {
      events.add(MoveCameraToCell(_context.gameField.cells.firstWhere((c) => c.nation == _context.nation)));
    }

    _context.updateGameObjectsEvent.update(events);

    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    return ReadyForInput();
  }

  void updateUnit(Unit unit, ProductionCenterType? cellProductionCenter) {
    unit.setFatigue(unit.maxFatigue);
    unit.setMovementPoints(unit.maxMovementPoints);

    final healthFactor = (unit.isMechanical && cellProductionCenter == ProductionCenterType.factory) ||
            (!unit.isMechanical && cellProductionCenter == ProductionCenterType.city) ||
            (unit.isShip && cellProductionCenter == ProductionCenterType.navalBase)
        ? partOfHealthRestoredWithProductionCenter
        : partOfHealthRestoredWithoutProductionCenter;

    final healthToAdd = unit.maxHealth * healthFactor;
    unit.setHealth(math.min(unit.health + healthToAdd, unit.maxHealth));
  }
}
