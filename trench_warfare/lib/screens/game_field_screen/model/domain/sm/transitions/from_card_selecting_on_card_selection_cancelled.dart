part of game_field_sm;

class FromCardSelectingOnCardsSelectionCancelled {
  late final MoneyUnit _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromCardSelectingOnCardsSelectionCancelled(
    MoneyUnit nationMoney,
      SimpleStream<GameFieldControlsState> controlsState,
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
