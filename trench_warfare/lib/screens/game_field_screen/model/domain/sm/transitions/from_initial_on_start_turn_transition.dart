part of game_field_sm;

class FromInitialOnOnStarTurnTransition extends GameObjectTransitionBase {
  final MoneyUnit _nationMoney;

  final SimpleStream<GameFieldControlsState> _controlsState;

  final Nation _nation;

  FromInitialOnOnStarTurnTransition(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nation,
    this._controlsState,
    this._nationMoney,
  );

  State process() {
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    List<UpdateGameEvent> events = [];

    final cellsToAdd = _gameField.cells.where((c) => c.nation != null);
    events.addAll(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));
    events.add(MoveCameraToCell(_gameField.cells.firstWhere((c) => c.nation == _nation)));

    _updateGameObjectsEvent.update(events);

    return ReadyForInput();
  }
}
