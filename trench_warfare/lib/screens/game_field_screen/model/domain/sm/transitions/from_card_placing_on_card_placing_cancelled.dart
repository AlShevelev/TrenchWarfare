part of game_field_sm;

class FromCardPlacingOnCardPlacingCancelled {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromCardPlacingOnCardPlacingCancelled(
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
