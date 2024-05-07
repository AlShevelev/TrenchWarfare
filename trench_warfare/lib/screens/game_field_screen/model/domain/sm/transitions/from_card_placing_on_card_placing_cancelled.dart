part of game_field_sm;

class FromCardPlacingOnCardPlacingCancelled extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromCardPlacingOnCardPlacingCancelled(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyUnit nationMoney,
    required SingleStream<GameFieldControlsState> controlsState,
  }) {
    _nationMoney = nationMoney;
    _controlsState = controlsState;
  }

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild) {
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    _updateGameObjectsEvent.update([
      UpdateCellInactivity(
        newInactiveCells: {},
        oldInactiveCells: cellsImpossibleToBuild,
      )
    ]);

    return ReadyForInput();
  }
}
