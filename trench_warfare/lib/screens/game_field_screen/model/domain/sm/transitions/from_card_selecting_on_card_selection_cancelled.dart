part of game_field_sm;

class FromCardSelectingOnCardsSelectionCancelled {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromCardSelectingOnCardsSelectionCancelled(
    MoneyUnit nationMoney,
    SingleStream<GameFieldControlsState> controlsState,
  ) {
    _nationMoney = nationMoney;
    _controlsState = controlsState;
  }

  State process() {
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    return ReadyForInput();
  }
}
