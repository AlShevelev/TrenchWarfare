part of game_field_sm;

class FromCardSelectingOnCardsSelected {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromCardSelectingOnCardsSelected(
      this._nationMoney,
      this._controlsState,
    );

  State process(GameFieldControlsCard card) {
    _controlsState.update(CardsPlacingControls(
      totalMoney: _nationMoney,
      card: card,
    ));

    // the cells, are possible to place the card must be calculated here
    // use _updateGameObjectsEvent

    return CardPlacing(card);
  }
}
