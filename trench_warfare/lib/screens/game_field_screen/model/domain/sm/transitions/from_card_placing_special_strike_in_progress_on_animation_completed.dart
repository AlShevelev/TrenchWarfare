part of game_field_sm;

class FromCardPlacingSpecialStrikeInProgressOnAnimationCompleted extends GameObjectTransitionBase {
  late final GameFieldControlsCard _card;

  late final Map<int, GameFieldCellRead> _newInactiveCells;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final MoneyUnit _productionCost;

  late final bool _canPlaceNext;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final MoneyStorage _nationMoney;

  FromCardPlacingSpecialStrikeInProgressOnAnimationCompleted(
    super.updateGameObjectsEvent,
    super.gameField, {
    required GameFieldControlsCard card,
    required Map<int, GameFieldCellRead> newInactiveCells,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required MoneyUnit productionCost,
    required bool canPlaceNext,
    required SingleStream<GameFieldControlsState> controlsState,
    required Nation myNation,
    required MapMetadataRead mapMetadata,
    required MoneyStorage nationMoney,
  }) {
    _card = card;
    _newInactiveCells = newInactiveCells;
    _oldInactiveCells = oldInactiveCells;
    _productionCost = productionCost;
    _canPlaceNext = canPlaceNext;
    _controlsState = controlsState;
    _oldInactiveCells = oldInactiveCells;
    _nationMoney = nationMoney;
  }

  State process() {
    // Update the money
    _nationMoney.withdraw(_productionCost);

    if (_canPlaceNext) {
      _controlsState.update(CardsPlacingControls(
        totalMoney: _nationMoney.actual,
        card: _card,
      ));

      _updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: _newInactiveCells,
          oldInactiveCells: _oldInactiveCells,
        )
      ]);

      return CardPlacing(_card, _newInactiveCells);
    } else {
      _controlsState.update(MainControls(
        money: _nationMoney.actual,
        cellInfo: null,
        armyInfo: null,
      ));

      _updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: {},
          oldInactiveCells: _oldInactiveCells,
        )
      ]);

      return ReadyForInput();
    }
  }
}
