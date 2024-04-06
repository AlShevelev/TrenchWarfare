part of game_field_sm;

class FromReadyForInputOnCardsClose {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnCardsClose(
    this._nationMoney,
    this._controlsState,
  );

  State process() {
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
    ));

    return ReadyForInput();
  }
}
