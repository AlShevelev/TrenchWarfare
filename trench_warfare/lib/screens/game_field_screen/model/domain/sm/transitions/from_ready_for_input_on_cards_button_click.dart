part of game_field_sm;

class FromReadyForInputOnCardsButtonClick {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnCardsButtonClick(
    this._nationMoney,
    this._controlsState,
  );

  State process() {
    _controlsState.update(Cards(
      money: _nationMoney,
    ));

    return ReadyForInput();
  }
}
