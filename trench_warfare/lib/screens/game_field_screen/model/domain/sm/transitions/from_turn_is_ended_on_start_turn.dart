part of game_field_sm;

class FromTurnIsEndedOnStartTurn extends GameObjectTransitionBase {
  static const partOfHealthRestoredWithoutProductionCenter = 0.2;
  static const partOfHealthRestoredWithProductionCenter = 0.4;

  final MoneyStorage _money;

  final SingleStream<GameFieldControlsState> _controlsState;

  final Nation _nation;

  final GameFieldSettingsStorageRead _gameFieldSettingsStorage;

  FromTurnIsEndedOnStartTurn(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nation,
    this._money,
    this._controlsState,
    this._gameFieldSettingsStorage,
  );

  State process() {
    _money.recalculate();

    final List<UpdateGameEvent> events = [];

    for (var cell in _gameField.cells) {
      if (cell.nation != _nation || cell.units.isEmpty) {
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

    events.add(SetCamera(_gameFieldSettingsStorage.zoom, _gameFieldSettingsStorage.cameraPosition));

    _updateGameObjectsEvent.update(events);

    _controlsState.update(MainControls(
      money: _money.actual,
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
