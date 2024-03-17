part of game_field_sm;

class FromInitialOnInitTransition extends GameObjectTransitionBase {
  late final NationRecord _nationRecord;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromInitialOnInitTransition(
    super.updateGameObjectsEvent,
    SingleStream<GameFieldControlsState> controlsState,
    super.gameField,
    NationRecord nationRecord,
  ) {
    _controlsState = controlsState;
    _nationRecord = nationRecord;
  }

  State process() {
    _controlsState.update(Visible(
      money: _nationRecord.startMoney,
      industryPoints: _nationRecord.startIndustryPoints,
      cellInfo: null,
      armyInfo: null,
    ));

    final cellsToAdd = _gameField.cells.where((c) => c.nation != null);
    _updateGameObjectsEvent.update(cellsToAdd.map((c) => UpdateObject(c)));

    return ReadyForInput();
  }
}
