part of game_field_sm;

class FromInitialOnInitTransition extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromInitialOnInitTransition(
    super.updateGameObjectsEvent,
    super.gameField,
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

    final cellsToAdd = _gameField.cells.where((c) => c.nation != null);
    _updateGameObjectsEvent.update(cellsToAdd.map((c) => UpdateCell(c, updateBorderCells: [])));

    return ReadyForInput();
  }
}
