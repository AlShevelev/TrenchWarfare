part of game_field_sm;

class FromReadyForInputOnLongClickEnd {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnLongClickEnd(
    this._nationMoney,
    this._controlsState,
  );

  State process() {
    _controlsState.update(Visible(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
    ));

    return ReadyForInput();
  }
}
